class RenameCommentsTargetAgentsToOrders < ActiveRecord::Migration[5.0]
  def change
    rename_table :comments_target_agents, :orders
  end
end
