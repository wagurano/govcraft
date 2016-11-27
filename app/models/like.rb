class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likable, polymorphic: true, counter_cache: true

  validates :user, uniqueness: { scope: [:likable_id, :likable_type] }

  def self.liked?(likable, user)
    Like.exists?(likable: likable, user: user)
  end
end
