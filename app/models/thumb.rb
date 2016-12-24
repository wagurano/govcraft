class Thumb < ApplicationRecord
  belongs_to :thumbable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: [ :thumbable_id, :thumbable_type] }
end

