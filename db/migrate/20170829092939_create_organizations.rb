class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.references :user, null: true
      t.string :title, null: false
      t.text :description
      t.string :slug, null: false
      t.string :logo
      t.timestamps null: false
    end
  end
end
