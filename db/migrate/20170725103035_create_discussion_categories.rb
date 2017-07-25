class CreateDiscussionCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :discussion_categories, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.string :title
      t.references :project, null: false, index: true
      t.integer :discussions_count, default: 0, null: false
      t.timestamps null: false
    end

    add_index :discussion_categories, [:title, :project_id], unique: true
  end
end
