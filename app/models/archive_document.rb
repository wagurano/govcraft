class ArchiveDocument < ApplicationRecord
  acts_as_taggable

  BULK_META = %i(id title body content_creator content_created_date
    content_created_time content_source donor is_secret_donor
    content_recipients media_type
    remote_content_url category_slug tag_list)

  extend Enumerize
  enumerize :media_type, in: %i(문서 사진 도면 영상 음성)

  before_save :update_content_attributes

  belongs_to :user
  belongs_to :archive
  belongs_to :category, class_name: ArchiveCategory, optional: true, primary_key: :slug, foreign_key: :category_slug
  has_many :comments, as: :commentable

  mount_uploader :content, PrivateFileUploader

  validates :title, presence: true
  validates :body, presence: true
  validates :media_type, presence: true
  validates :category_slug, presence: true

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

  def parse_content_created_date
    return [nil, nil, nil] if content_created_date.blank?

    year = content_created_date[0..3]
    month = content_created_date[4..5]
    day = content_created_date[6..7]

    [year, (month if month != "00"), (day if day != "00")]
  end

  def self.bulk_human_attribute_names
    BULK_META.map { |a| human_attribute_name(a) }
  end

  def self.bulk_human_attribute_helps
    BULK_META.map { |a| I18n.t("messages.xlsx_help.archive_document.#{a}", default: "") }
  end

  def self.bulk_attribute_index(attribute)
    BULK_META.index(attribute.to_sym)
  end

  private

  def update_content_attributes
    if content.present? && content_changed?
      self.content_type = content.file.content_type
      self.content_size = content.file.size
    end
  end
end
