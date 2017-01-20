class CreateOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :options, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.references :survey, null: false, index: true
      t.text :body
      t.integer :feedbacks_count, default: 0, null: false
      t.timestamps null: false
    end
  end
end
