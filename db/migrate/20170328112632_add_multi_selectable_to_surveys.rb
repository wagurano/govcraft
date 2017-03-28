class AddMultiSelectableToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :multi_selectable, :boolean, null: false, default: false
  end
end
