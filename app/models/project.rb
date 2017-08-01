class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  belongs_to :user
  has_many :discussions, dependent: :destroy
  has_many :petitions, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :wikis, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :surveys, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :discussion_categories, dependent: :destroy
  has_many :project_admins, dependent: :destroy

  mount_uploader :image, ImageUploader

  scope :recent, -> { order('id DESC') }

  validates :slug, format: { with: /\A[a-z0-9]+\z/i }, uniqueness: true

  after_create :fallback_slug

  def component_title(modle_name)
    model = modle_name.classify.safe_constantize
    name_by_model = model.blank? ? I18n.t("activerecord.models.#{modle_name}") : model.model_name.human
    send(:"#{modle_name}_title").blank? ? name_by_model : send(:"#{modle_name}_title")
  end

  def poll_and_survey_title
    poll_title
  end

  def participated? someone
    participations.exists? user: someone
  end

  def polls_and_surveys_recent
    [polls + surveys].flatten.sort_by(&:created_at).reverse
  end

  def project_admin? someone
    project_admins.exists? user: someone
  end

  private

  def fallback_slug
    if self.slug.blank?
      update_columns(slug: self.id)
    end
  end
end
