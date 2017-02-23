require 'json'
require 'rest-client'

class ClypitJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform
    document = ArchiveDocument.left_outer_joins(:clypit).find_by(media_type: '음성', clypits: { id: nil })
    if document.read_attribute(:content).blank?
      logger.info("Document ##{document.id} : no content")
      return
    end

    if document.content.file.respond_to?(:url)
      data = open document.content.url
    else
      data = open document.content.path
    end


    auth_response = RestClient.post("https://api.clyp.it/oauth2/token",
      {
        grant_type: 'password',
        username: ENV['CLYPIT_USERNAME'],
        password: ENV['CLYPIT_PASSWORD']
      },
      {Authorization: 'Basic MjkzMTE5Og=='}
    )

    auth = JSON.parse(auth_response.body)
    if auth['error'].present?
      logger.info("Clypit Auth fail : #{auth['error']}")
      return
    end
    access_token = auth['access_token']
    if access_token.blank?
      logger.info("Clypit Auth fail : no access_token")
      return
    end

    upload_response = RestClient.post("https://upload.clyp.it/upload",
      {
        audioFile: data,
        description: "#{document.title} #{Rails.application.routes.url_helpers.archive_document_url(document)}"
      },
      {
        'X-Client-Type': 'WebAlfa',
        'Authorization': "Bearer #{access_token}"
      }
    )

    upload_result = JSON.parse(upload_response.body)
    if upload_result["Successful"]
      document.build_clypit(audio_file_id: upload_result["AudioFileId"])
    else
      logger.info("Clypit Auth fail : #{upload_result['Title']} - #{upload_result['Description']}")
      document.build_clypit
    end

    document.save!
  end
end
