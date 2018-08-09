class AddReadAtToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :read_at, :datetime
  end
end
