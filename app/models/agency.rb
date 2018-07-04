class Agency < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  mount_uploader :image, ImageUploader

  include Positionable

  # X_POSITION
  # acts_as_taggable_on :positions
  has_and_belongs_to_many :positions, -> { distinct }
  has_many :agents, through: :positions

  # X_POSITION
  # def agents
  #   Agent.tagged_with(position_list, on: :positions, any: true)
  # end
end
