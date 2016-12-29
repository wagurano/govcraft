class Speech < ApplicationRecord
  belongs_to :user
  belongs_to :event

  scope :recent, -> { order('id DESC') }
end
