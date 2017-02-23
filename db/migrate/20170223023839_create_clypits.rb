class CreateClypits < ActiveRecord::Migration[5.0]
  def change
    create_table :clypits, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.references :archive_document, null: false, index: true
      t.string :audio_file_id, index: true
      t.timestamps null: false
    end
  end
end
