class AddNeutralsCountToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :neutrals_count, :integer, default: 0, null: false
  end
end
