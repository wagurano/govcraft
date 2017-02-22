class BulkTask < ApplicationRecord
  belongs_to :user
  belongs_to :archive

  attr_accessor :error_dict

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

  def target_model
    ArchiveDocument
  end

  def serialize_error_detail
    self.error_detail = (self.error_dict.sort[0..1000].to_h.to_json if self.error_dict.present? and self.error_dict.any?)
  end

  def set_current_error message
    self.error_dict ||= {}
    self.error_dict[self.processing_count + 1] = message
    self.error_count = self.error_dict.count
  end
end
