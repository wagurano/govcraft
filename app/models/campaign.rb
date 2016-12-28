class Campaign < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  belongs_to :user
  has_many :discussions, dependent: :destroy
  has_many :petitions, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :wikis, dependent: :destroy
  has_many :events, dependent: :destroy

  mount_uploader :image, ImageUploader

  scope :recent, -> { order('id DESC') }

  validates :slug, format: { with: /\A[a-z0-9]+\z/i }, uniqueness: true

  after_create :fallback_slug

  def component_title(modle_name)
    model = modle_name.classify.safe_constantize
    return if model.blank?
    send(:"#{modle_name}_title").blank? ? model.model_name.human : send(:"#{modle_name}_title")
  end

  private

  def fallback_slug
    if self.slug.blank?
      update_columns(slug: self.id)
    end
  end
end
