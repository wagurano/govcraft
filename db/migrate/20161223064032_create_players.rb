class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :person, null: false, index: true
      t.references :user, null: false, index: true
      t.references :race, null: false, index: true
      t.integer :thumbs_up_count, default: 0
      t.integer :thumbs_down_count, default: 0
      t.integer :thumbs_middle_count, default: 0
      t.timestamps null: false
      t.index [:race_id, :person_id], unique: true
    end
  end
end
