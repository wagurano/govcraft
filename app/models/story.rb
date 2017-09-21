class Story < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy

  mount_uploader :cover, ImageUploader

  scope :recent, -> { order('id DESC') }
  scope :by_organization, ->(organization) { where(project: organization.projects) }

  def fallback_social_image_url
    if self.read_attribute(:cover).present?
      self.cover_url
    else
      self.project.try(:social_image_url)
    end
  end
end
