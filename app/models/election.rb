class Election < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :candidates, dependent: :destroy

  mount_uploader :image, ImageUploader

  scope :recent, -> { order('id DESC') }
end
