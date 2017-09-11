class Comment < ApplicationRecord
  include Likable
  include Choosable
  include Reportable

  extend Enumerize
  enumerize :mailing, in: %i(disable ready sent fail)

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  geocoded_by :full_street_address

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :target_speaker, optional: true, class_name: Speaker

  mount_uploader :image, ImageUploader

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }
  scope :with_target_speaker, ->(speaker) { where(target_speaker: speaker) }

  validates :body, presence: true
  validates :commenter_email, format: { with: Devise.email_regexp }, if: 'commenter_email.present?'
  validate :commenter_should_be_present_if_user_is_blank
  after_validation :fetch_geocode, if: ->(obj){ obj.full_street_address.present? and obj.full_street_address_changed? }

  before_save :save_gps

  def user_nickname
    user.present? ? user.nickname : commenter_name
  end

  def user_email
    user.present? ? user.email : commenter_email
  end

  def commentable_title
    commentable.commentable_title
  end

  private

  def save_gps
    begin
      if self.image.present? and self.full_street_address.blank?
        gps = EXIFR::JPEG.new(self.image.file.path).gps
        if gps.present?
          self.latitude = gps.latitude
          self.longitude = gps.longitude
        end
      end
    rescue EXIFR::MalformedJPEG => e
    end
  end

  def commenter_should_be_present_if_user_is_blank
    if user.blank? and commenter_name.blank?
      errors.add(:commenter_name, I18n.t('activerecord.errors.models.comment.commenter.blank'))
    end
  end

  private

  def fetch_geocode
    self.latitude = nil
    self.longitude = nil
    geocode
  end
end
