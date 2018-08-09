class RenameCommentsTargetAgentsToOrder < ActiveRecord::Migration[5.0]
  def change
    rename_table :comments_target_agent, :order
  end
end
