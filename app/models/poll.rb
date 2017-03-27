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
end
