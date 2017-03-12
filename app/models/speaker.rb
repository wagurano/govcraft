class Speaker < ApplicationRecord
  validates :name, presence: true
  mount_uploader :image, UserImageUploader
end

