class Poll < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable
  has_many :likes, as: :likable
  has_many :votes, dependent: :destroy

  scope :recent, -> { order('id DESC') }

  def fetch_vote_of someone
    votes.find_by user: someone
  end

  def voted_by? someone
    votes.exists? user: someone
  end
end
