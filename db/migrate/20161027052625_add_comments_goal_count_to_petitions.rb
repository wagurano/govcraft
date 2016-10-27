class AddCommentsGoalCountToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :comments_goal_count, :integer, default: 1000
  end
end
