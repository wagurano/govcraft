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
        s.position_list = '국회의원'
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
      Speaker.tagged_with("국회의원").each do |speaker|
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
end
