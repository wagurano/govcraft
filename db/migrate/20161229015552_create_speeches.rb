class CreateSpeeches < ActiveRecord::Migration[5.0]
  def change
    create_table :speeches, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC"  do |t|
      t.string :title, null: false
      t.string :video_url, null: false
      t.references :event, null: false, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
