class Organizer < ApplicationRecord
  belongs_to :user
  belongs_to :organizable, polymorphic: true

  validates :organizable_id, uniqueness: { scope: [:organizable_type, :user_id] }, presence: true
end
