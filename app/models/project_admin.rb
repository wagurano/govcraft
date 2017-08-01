class ProjectAdmin < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :project, uniqueness: { scope: [:user_id] }, presence: true
end
