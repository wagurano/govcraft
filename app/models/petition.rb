class Petition < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable
  has_many :likes, as: :likable
  has_many :signs, dependent: :destroy
  has_many :signed_users, through: :signs, source: :petition

  def signed? someone
    signed_users.exists?(user: someone)
  end
end
