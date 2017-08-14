class Poll < ApplicationRecord
  include Likable
  include Votable

  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy

  mount_uploader :cover_image, ImageUploader
  mount_uploader :social_card, ImageUploader
  scope :recent, -> { order('id DESC') }

  def has_cover_image?
    cover_image.file.present?
  end

  def fallback_social_image_url
    if self.project.try(:read_attribute, :social_image).present?
      self.project.social_image_url
    end
  end
end
