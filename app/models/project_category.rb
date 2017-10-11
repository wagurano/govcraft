class ProjectCategory < ApplicationRecord
  belongs_to :organization
  has_many :projects, dependent: :nullify
end
