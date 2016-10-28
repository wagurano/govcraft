class Sign < ApplicationRecord
  belongs_to :user
  belongs_to :petition, counter_cache: true

  validates :user, uniqueness: { scope: :petition }
end
