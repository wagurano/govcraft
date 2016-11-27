class Event < ApplicationRecord
  TEMPLATES = %w( default map )

  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable

  mount_uploader :image, ImageUploader

  scope :recent, -> { order('id DESC') }
end
