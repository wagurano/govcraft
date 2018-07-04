class Position < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :agents, through: :appointments
  has_and_belongs_to_many :agencies, -> { distinct }

  scope :named, ->(*names) { where(name: names) }
end
