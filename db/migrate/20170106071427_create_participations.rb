class CreateParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :participations do |t|
      t.references :user, null: false, index: true
      t.references :project, null: false, index: true
      t.timestamps null: false
      t.index [:user_id, :project_id], unique: true
    end
  end
end
