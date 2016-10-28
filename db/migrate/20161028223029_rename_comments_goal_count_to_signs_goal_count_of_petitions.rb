class RenameCommentsGoalCountToSignsGoalCountOfPetitions < ActiveRecord::Migration[5.0]
  def change
    rename_column :petitions, :comments_goal_count, :signs_goal_count
  end
end
