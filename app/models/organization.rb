class Organization < ApplicationRecord
  has_many :projects, dependent: :nullify
  has_many :project_categories, dependent: :nullify

  def subdomain
    [slug, ApplicationController.helpers.root_subdomain].compact.join(".")
  end
end

