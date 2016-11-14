class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy

  scope :recent, -> { order('id DESC') }
end
