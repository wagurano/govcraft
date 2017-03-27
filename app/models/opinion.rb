class Opinion < ApplicationRecord
  include Likable
  include Votable

  belongs_to :speaker
  belongs_to :issue
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, dependent: :destroy

  scope :recent, -> { order('id DESC') }
  scope :of_issue, ->(issue) { where(issue: issue) }
  scope :of_quote, ->(quote) { where(quote: quote) }
  scope :of_speaker, ->(speaker) { where(speaker: speaker) }
end
