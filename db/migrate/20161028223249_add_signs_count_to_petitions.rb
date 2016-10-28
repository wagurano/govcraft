class AddSignsCountToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :signs_count, :integer, defult: 0
  end
end
