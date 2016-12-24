class CreateThumbStats < ActiveRecord::Migration[5.0]
  def change
    create_table :thumb_stats do |t|
      t.references :race, null: false, index: true
      t.references :player, null: false, index: true
      t.integer :thumbs_up_count, default: 0
      t.integer :thumbs_down_count, default: 0
      t.date :stated_at
      t.timestamps null: false
    end
  end
end
