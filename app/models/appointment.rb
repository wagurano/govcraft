class Appointment < ApplicationRecord
  belongs_to :agent
  belongs_to :position

  scope :of_positions_named, -> (*position_names) { where(position: Position.named(position_names)) }
  scope :of_positions, -> (*positions) { where(position: positions) }
end
