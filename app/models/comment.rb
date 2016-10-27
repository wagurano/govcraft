class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }
  validates :body, presence: true
end
