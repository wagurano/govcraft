class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.references :user, index: true, null: false
      t.references :survey, index: true, null: false
      t.references :option, index: true, null: false
      t.timestamps null: false

      t.index [:user_id, :survey_id], unique: true
    end
  end
end
