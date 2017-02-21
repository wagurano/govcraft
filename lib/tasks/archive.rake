namespace :archive do
  desc "인자 [:archive_id, :google_folder_id]가 필수, 구글드라이브 폴더내의 파일을 아카이브업로드포멧 엑셀로 만듭니다."
  task 'generate_format:google_drive', [:archive_id, :default_category_slug, :google_folder_id] => :environment do |t, args|
    session = GoogleDrive::Session.from_config("google-drive-config.json")
    collection = session.file_by_id(args[:google_folder_id])
    if collection.resource_type != 'folder'
      puts "폴더가 아닙니다"
      return
    end

    archive = Archive.find_by(id: args[:archive_id])
    if archive.blank?
      puts "해당 아카이브를 찾을 수 없습니다"
      return
    end
    unless archive.subcategories.exists? slug: args[:default_category_slug]
      puts "해당 카테고리를 찾을 수 없습니다"
      return
    end

    puts ApplicationController.renderer.render(
      handlers: [:axlsx],
      layout: false,
      template: '/bulk_tasks/template',
      formats: [:xlsx],
      locals: {
        archive: archive,
        google_drive_files: collection.files,
        default_category_slug: args[:default_category_slug]
      }
    )
  end
end
