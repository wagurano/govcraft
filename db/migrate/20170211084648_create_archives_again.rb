class CreateArchivesAgain < ActiveRecord::Migration[5.0]
  def change
    create_table :archives, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC"  do |t|
      t.string :title, null: false
      t.text :body
      t.string :cover_image
      t.string :social_image
      t.references :user, index: true, null: false
      t.integer :comments_count, default: 0
      t.integer :likes_count, default: 0

      t.timestamps null: false
    end
  end
end
