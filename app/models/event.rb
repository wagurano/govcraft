class Event < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable
  mount_uploader :image, ImageUploader
end
