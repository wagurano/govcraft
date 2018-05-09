namespace :data do
  desc '국회의원 데이터가 비어있으면 로드합니다'
  task 'load_once_assembly_members' => :environment do
    if AssemblyMember.all.empty?
      AssemblyMember.refresh!
    end
  end

  desc '국회의원을 스피커로 등록합니다'
  task 'register_assembly_members_to_speaker' => :environment do
    ActiveRecord::Base.transaction do
      AssemblyMember.all.select(:empNm, :assemEmail, :polyNm).each do |assembly_member|
        s = Speaker.new(name: assembly_member[:empNm], organization: assembly_member[:polyNm],
         email: assembly_member[:assemEmail], category: '')
        s.position_list = '20대_국회의원'
        s.save!
      end
    end
  end

  desc '국회의원 정보를 갱신합니다'
  task 'reload_assembly_members' => :environment do
    AssemblyMember.update!
  end

  desc '국회의원의 이미지를 추가하고, 국회의원이 스피커가 되는 경우 스피커id를 넣어줍니다'
  task 'link_assembly_members_to_speaker_and_add_image' => :environment do
    ActiveRecord::Base.transaction do
      Speaker.tagged_with("20대_국회의원").each do |speaker|
        member = AssemblyMember.find_by(empNm: speaker.name, polyNm: speaker.organization)
        member.speaker_id = speaker.id
        member.save!
        speaker.remote_image_url = member.jpgLink
        speaker.save!
      end
    end
  end

  desc '이벤트 이미지 데이터를 받습니다'
  task 'download_event', [:id] => :environment do |task, args|
    event = Event.find args[:id]
    Dir.mktmpdir do |dir|
      zipFileName = "event_#{event.id}.zip"
      Zip::File.open(zipFileName, Zip::File::CREATE) do |zipFile|
        event.comments.each do |comment|
          next if comment.read_attribute(:image).blank?
          puts comment.image.url
          file_name = "#{comment.id}_#{comment.read_attribute(:image)}"
          file_path = File.join(dir, file_name)
          if comment.image.file.respond_to?(:url)
            # s3
            File.open(file_path, 'wb') do |file|
              file << open(comment.image.url).read
            end
          else
            # local storage
            FileUtils.cp(comment.image.path, file_path)
          end
          zipFile.add(file_name, file_path)
        end
      end
    end
  end

  desc '630 단체 데이터를 넣습니다'
  task '630', [:file, :archive_id] => :environment do |task, args|
    xlsx = Roo::Spreadsheet.open args[:file]
    ActiveRecord::Base.transaction do
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        if empty_row?(row)
          break
        end
        model_instance = ArchiveDocument.new
        model_instance.build_additional
        process_model(row, model_instance, args[:archive_id])
      end
    end
  end

  desc "seed areas"
  task 'seed:areas' => :environment do
    count = 0
    ActiveRecord::Base.transaction do
      Area.delete_all
      now = DateTime.now
      Area.bulk_insert(:code, :division, :subdivision, :neighborhood, :created_at, :updated_at) do |worker|
        xlsx = Roo::Spreadsheet.open(Rails.root.join('lib', 'tasks', 'area_20180401.xlsx').to_s)

        index_area_division_code = 1
        index_area_subdivision_code = 3
        index_area_code = 5

        index_area_division = 2
        index_area_subdivision = 4
        index_area_neighborhood = 6

        xlsx.sheet("Data").each_row_streaming(pad_cells: true) do |row|
          division_code = row[index_area_division_code].try(:cell_value)
          next if division_code.blank?

          subdivision_code = row[index_area_subdivision_code].try(:cell_value)
          code = row[index_area_code].try(:cell_value)
          if code.blank?
            if subdivision_code.blank?
              code = division_code + "000" + "00"
            else
              code = subdivision_code + "00"
            end
          end

          division = row[index_area_division].try(:cell_value)
          subdivision = row[index_area_subdivision].try(:cell_value)
          neighborhood = row[index_area_neighborhood].try(:cell_value)

          worker.add [code, division, subdivision, neighborhood, now, now]
          count += 1
          print '.' if (count % 1000.0) == 0
        end
      end
    end
    puts '.' if count > 0
  end

  def empty_row? row
    row[0].nil? or row[0].formatted_value.try(:strip).blank?
  end

  def process_model(row, model_instance, archive_id)
    process_attributes(row, model_instance, archive_id)
    model_instance.user = User.find_by(nickname: '갱')
    model_instance.archive_id = archive_id
    model_instance.body = "#{model_instance.additional.address} #{model_instance.additional.homepage}"
    if model_instance.body.strip.blank?
      model_instance.body = model_instance.title
    end
    model_instance.save!
  end

  def process_attributes(row, model_instance, archive_id)
    parent_category = nil
    attributes = %i(category title tag1 tag2 sub_region npo_type address zipcode homepage tel fax leader leader_tel email)
    attributes.each do |name|
      process_method = :"process_bulk_of_#{name}"
      value = fetch_data(row, attributes, name).try(:strip)

      next if value.blank?
      if [:tag1, :tag2].include? name
        model_instance.tag_list.add(value)
      elsif :category == name
        category = ArchiveCategory.find_by(archive_id: archive_id, slug: value)
        if category.blank?
          category = ArchiveCategory.create!(archive_id: archive_id, slug: value, name: value)
        end
        parent_category = category
      elsif :sub_region == name
        slug = "#{parent_category.slug}-#{value}"
        category = ArchiveCategory.find_by(archive_id: archive_id, parent_id: parent_category.id, slug: slug)
        if category.blank?
          category = ArchiveCategory.create!(archive_id: archive_id, parent_id: parent_category.id, slug: slug, name: value)
        end
        model_instance.category_slug = category.slug
      elsif :title == name
        model_instance.assign_attributes(name => value)
      elsif :homepage == name
        model_instance.additional.assign_attributes(name => ActionView::Base.full_sanitizer.sanitize(value))
      else
        model_instance.additional.assign_attributes(name => value)
      end
    end

    print("#{parent_category.name}-#{model_instance.category.name} : #{model_instance.title}\n")
  end

  def fetch_data(row, attributes, name)
    row[attributes.index(name)].try(:formatted_value)
  end
end
