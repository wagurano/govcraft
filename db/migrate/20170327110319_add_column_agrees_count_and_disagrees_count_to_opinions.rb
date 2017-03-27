class AddColumnAgreesCountAndDisagreesCountToOpinions < ActiveRecord::Migration[5.0]
  def change
    add_column :opinions, :agrees_count, :integer, default: 0
    add_column :opinions, :disagrees_count, :integer, default: 0
  end
end
