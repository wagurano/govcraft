class CreateStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :statements, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.belongs_to :petition, null: false, index: true
      t.belongs_to :speaker, null: false, index: true
      t.string :key, null: false
      t.text :body
      t.string :stance
      t.timestamps null: false
    end
  end
end
