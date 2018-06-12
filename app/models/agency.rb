class Agency < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  mount_uploader :image, ImageUploader
  acts_as_taggable_on :positions

  def agents
    Agent.tagged_with(position_list, on: :positions, any: true)
  end
end
