class AddClosedAtToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :closed_at, :datetime
  end
end
