class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable
  has_many :likes, as: :likable

  scope :recent, -> { order('updated_at DESC') }
end
