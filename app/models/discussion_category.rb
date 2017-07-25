class DiscussionCategory < ApplicationRecord
  belongs_to :project
  has_many :discussions, dependent: :nullify

  validates :title, uniqueness: { scope: [:project_id], case_sensitive: false }, presence: true
end
