module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def fetch_vote_of someone
    votes.find_by user: someone
  end

  def voted_by? someone
    votes.exists? user: someone
  end
end
