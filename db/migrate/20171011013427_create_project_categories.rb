class CreateProjectCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :project_categories, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.references :organization, null: false, index: true
      t.timestamp null: false
      t.string :slug, null: false, index: true
      t.string :title, null: false
    end
  end
end
