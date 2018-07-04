module Positionable
  extend ActiveSupport::Concern

  included do
    before_save :build_positions_by_position_name_list
  end

  def position_name_list
    return @_position_name_list if @_position_name_list.present?

    @_position_name_list = positions.map(&:name).join(', ')
    @_position_name_list
  end

  def position_name_list=(names)
    @_position_name_list_touched = true
    @_position_name_list = names
  end

  def build_positions_by_position_name_list
    if @_position_name_list_touched
      rebuilding_position_names = []
      if @_position_name_list.present?
        rebuilding_position_names = @_position_name_list.split(',').map(&:strip)
      end

      rebuilding_positions = Position.named(*rebuilding_position_names).to_a

      self.positions.where.not(id: rebuilding_positions).destroy_all
      rebuilding_positions.each do |position|
        if !self.positions.exists?(id: position)
          positions << position
        end
      end
    end
    @_position_name_list_touched = false
  end
end
