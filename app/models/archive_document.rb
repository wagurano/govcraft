class ArchiveDocument < ApplicationRecord
  acts_as_taggable

  XLXS_META = %i(id title body content_creator content_created_date content_created_time content_source is_secret_content_source remote_content_url category_slug)

  before_save :update_content_attributes

  belongs_to :user
  belongs_to :archive
  belongs_to :category, class_name: ArchiveCategory, optional: true, primary_key: :slug, foreign_key: :category_slug
  has_many :comments, as: :commentable

  mount_uploader :content, PrivateFileUploader

  default_scope { order('content_created_date DESC, content_created_time DESC, created_at DESC, id DESC') }
  scope :recent, -> { order('id DESC') }

  def original_filename_attribute
    :content_name
  end

  def image?
    content_type.start_with? 'image'
  end

  def valid_name
    self.content_name.gsub(/\\+/, "%20")
  end

  def self.xlxs_human_attribute_names
    XLXS_META.map { |a| human_attribute_name(a) }
  end

  def self.xlxs_human_attribute_helps
    XLXS_META.map { |a| I18n.t("messages.xlsx_help.archive_document.#{a}", default: "") }
  end

  private

  def update_content_attributes
    if content.present? && content_changed?
      self.content_type = content.file.content_type
      self.content_size = content.file.size
    end
  end
end
