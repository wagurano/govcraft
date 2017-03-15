class Speaker < ApplicationRecord
  has_many :opinions, dependent: :destroy
  validates :name, presence: true
  mount_uploader :image, UserImageUploader

  scope :of_position, ->(position) { tagged_with(position, on: :positions) }

  acts_as_taggable_on :positions
end

