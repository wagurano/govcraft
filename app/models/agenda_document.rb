class AgendaDocument < ApplicationRecord
  belongs_to :speaker
  belongs_to :agenda
  belongs_to :user, optional: true
  before_save :update_meta

  mount_uploader :attachment, DocumentUploader

  scope :recent, -> { order('id DESC') }
  scope :of_ageda, ->(agenda) { where(agenda: agenda) }

  def image?
    self.file_type.start_with? 'image'
  end

  def original_filename_attribute
    :name
  end

  private

  def update_meta
    if attachment.present? && attachment_changed?
      self.file_type = attachment.file.content_type
      self.file_size = attachment.file.size
    end
  end

end
