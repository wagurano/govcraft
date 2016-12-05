class Petition < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :signs, dependent: :destroy
  has_many :signed_users, through: :signs, source: :petition, dependent: :destroy

  mount_uploader :cover_image, ImageUploader

  scope :recent, -> { order('id DESC') }

  def signed? someone
    signed_users.exists?(user: someone)
  end

  def percentage
    signs_goal_count > 0 ? ( signs_count.to_f / signs_goal_count * 100 ).to_i : 100
  end

  def has_cover_image?
    cover_image.file.present?
  end
end
