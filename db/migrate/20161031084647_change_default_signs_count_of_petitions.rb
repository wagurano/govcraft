class ChangeDefaultSignsCountOfPetitions < ActiveRecord::Migration[5.0]
  def up
    change_column :petitions, :signs_count, :integer, default: 0
    execute <<-SQL
      UPDATE petitions SET signs_count = 0 WHERE signs_count is null
    SQL
  end
end
