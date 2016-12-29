class Speech < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :event

  paginates_per 4 * 8

  scope :recent, -> { order('id DESC') }
end
