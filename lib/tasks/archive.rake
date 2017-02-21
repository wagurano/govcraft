namespace :archive do
  desc "구글드라이브 폴더내의 파일을 아카이브업로드포멧 엑셀로 만듭니다"
  task 'generate_format:google_drive' => :environment do
    session = GoogleDrive::Session.from_config("google-drive-config.json")
    @collection = session.file_by_id('0B-fm2H4nFtqlajctUGhSbW4tZHM')
    puts '폴더가 아닙니다' and return if @collection.resource_type != 'folder'
    puts @collection.files.inspect
  end
end
