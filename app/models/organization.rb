class Organization < ApplicationRecord
  has_many :projects
  has_many :project_categories, dependent: :nullify
end
