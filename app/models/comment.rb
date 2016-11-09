class Comment < ApplicationRecord
  include Choosable
  include Reportable

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :likes, as: :likable

  mount_uploader :image, ImageUploader

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }

  validates :body, presence: true
  validates :commenter_email, format: { with: Devise.email_regexp }, if: 'commenter_email.present?'
  validate :commenter_should_be_present_if_user_is_blank

  def user_nickname
    user.present? ? user.nickname : commenter_name
  end

  private

  def commenter_should_be_present_if_user_is_blank
    if user.blank? and commenter_name.blank?
      errors.add(:commenter_name, I18n.t('activerecord.errors.models.comment.commenter.blank'))
    end
  end
end
