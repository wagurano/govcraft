class ProjectAdmin < ApplicationRecord
  belongs_to :user
  belongs_to :adminable, polymorphic: true

  validates :adminable_id, uniqueness: { scope: [:adminable_type, :user_id] }, presence: true
end
