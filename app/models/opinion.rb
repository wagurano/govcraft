class Opinion < ApplicationRecord
  include Likable

  belongs_to :speaker
  belongs_to :issue
  has_many :comments, as: :commentable, dependent: :destroy

  scope :recent, -> { order('id DESC') }
  scope :of_issue, ->(issue) { where(issue: issue) }
  scope :of_quote, ->(quote) { where(quote: quote) }
  scope :of_speaker, ->(speaker) { where(speaker: speaker) }
end
