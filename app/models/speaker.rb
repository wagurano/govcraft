class Speaker < ApplicationRecord
  has_many :opinions, dependent: :destroy
  validates :name, presence: true
  mount_uploader :image, UserImageUploader
end

