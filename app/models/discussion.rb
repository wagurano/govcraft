class Discussion < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :discussion_category, optional: true, counter_cache: true

  scope :recent, -> { order('id DESC') }
  scope :by_organization, ->(organization) { where(project: organization.projects) }
  scope :pinned, -> { where.not(pinned_at: nil).order('pinned_at DESC') }

  def fallback_social_image_url
    if self.project.try(:read_attribute, :social_image).present?
      self.project.social_image_url
    end
  end
end
