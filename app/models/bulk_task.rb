class BulkTask < ApplicationRecord
  belongs_to :user
  belongs_to :archive

  extend Enumerize
  enumerize :status, in: %i(등록 대기 시작 완료 실패)

  mount_uploader :attachment, PrivateFileUploader
  validates_presence_of :attachment

  scope :recent, -> { order(id: :desc) }

  def error_detail_as_hash
    begin
      JSON.parse(error_detail)
    rescue JSON::ParserError => e
      return {}
    end
  end

  def original_filename_attribute
    :attachment_name
  end

  def valid_name
    self.attachment_name.gsub(/\\+/, "%20")
  end
end
