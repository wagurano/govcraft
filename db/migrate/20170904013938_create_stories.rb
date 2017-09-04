class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :stories, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, index: true
      t.references :project, index: true
      t.string :cover
      t.integer :reports_count, default: 0
      t.integer :likes_count, default: 0
      t.integer :views_count, default: 0
      t.integer :anonymous_likes_count, default: 0
      t.boolean  :comment_enabled, default: true

      t.timestamps null: false
    end
  end
end
