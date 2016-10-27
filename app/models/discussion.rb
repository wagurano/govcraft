class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable
end
