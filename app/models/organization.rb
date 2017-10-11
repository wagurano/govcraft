class Organization < ApplicationRecord
  has_many :projects, dependent: :nullify
  has_many :project_categories, dependent: :nullify
end
