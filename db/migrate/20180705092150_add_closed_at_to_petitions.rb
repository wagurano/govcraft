class AddClosedAtToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :closed_at, :datetime
  end
end
