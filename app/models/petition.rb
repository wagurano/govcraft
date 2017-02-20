class Petition < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :signs, dependent: :destroy
  has_many :signed_users, through: :signs, source: :petition

  mount_uploader :cover_image, ImageUploader
  mount_uploader :social_image, ImageUploader

  scope :recent, -> { order('id DESC') }

  def signed? someone
    signs.exists?(user: someone)
  end

  def has_goal?
    signs_goal_count.present? && signs_goal_count > 0
  end

  def percentage
    has_goal? ? ( signs_count.to_f / signs_goal_count * 100 ).to_i : 100
  end

  def has_cover_image?
    cover_image.file.present?
  end
end
