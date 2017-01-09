class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user, uniqueness: { scope: [:project_id] }

  scope :recent, -> { order('id DESC') }
end
