class Discussion < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable, dependent: :destroy

  scope :recent, -> { order('id DESC') }
end
