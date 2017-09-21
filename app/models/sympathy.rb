class Sympathy < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  mount_uploader :cover_image, ImageUploader
  mount_uploader :social_image, ImageUploader

  scope :recent, -> { order('id DESC') }
end
