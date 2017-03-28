class DropUniqIndexOfFeedbacks < ActiveRecord::Migration[5.0]
  def change
    remove_index :feedbacks, ["user_id", "survey_id"]
  end
end
