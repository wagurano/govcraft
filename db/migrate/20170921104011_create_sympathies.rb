class CreateSympathies < ActiveRecord::Migration[5.0]
  def change
    create_table :sympathies, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, null: true, index: true
      t.integer :views_count, default: 0
      t.integer :comments_count, default: 0
      t.string :cover_image
      t.string :social_image
      t.timestamps null: false
    end
  end
end
