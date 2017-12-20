class Organization < ApplicationRecord
  include Organizable
  has_many :projects, dependent: :nullify
  has_many :project_categories, dependent: :nullify

  def subdomain
    [slug, ApplicationController.helpers.root_subdomain].compact.join(".")
  end

  def seo_image_path
    if File.exists?(Rails.root.join('app', 'assets', 'images', 'organizations', slug, 'seo_image.png'))
      "organizations/#{slug}/seo_image.png"
    end
  end
end

