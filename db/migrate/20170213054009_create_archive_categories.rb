class CreateArchiveCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :archive_categories, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC"  do |t|
      t.references :archive, index: true, null: false
      t.references :parent, index: true
      t.string :slug, index: true, null: false
      t.string :name, null: false
      t.timestamps null: false

      t.index [:archive_id, :slug], unique: true
    end
  end
end
