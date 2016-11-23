class Poll < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy
  has_many :votes, dependent: :destroy

  mount_uploader :cover_image, ImageUploader
  mount_uploader :social_card, ImageUploader
  scope :recent, -> { order('id DESC') }

  def fetch_vote_of someone
    votes.find_by user: someone
  end

  def voted_by? someone
    votes.exists? user: someone
  end

  def has_cover_image?
    cover_image.file.present?
  end
end
