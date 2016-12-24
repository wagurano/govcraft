class Person < ApplicationRecord
  belongs_to :user
  has_many :players, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :name, presence: true

  scope :recent, -> { order('id DESC') }

  def image_present?
    self[:image].present?
  end
end
