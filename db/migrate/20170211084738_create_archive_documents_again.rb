class CreateArchiveDocumentsAgain < ActiveRecord::Migration[5.0]
  def change
    create_table :archive_documents, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, index: true, null: false
      t.references :archive, index: true, null: false
      t.integer :comments_count, default: 0
      t.integer :likes_count, default: 0

      t.string :content_creator
      t.date :content_created_date
      t.string :content_created_time
      t.string :content_source
      t.boolean :is_secret_content_source

      t.string  :content, null: false
      t.string  :content_name, null: false
      t.string  :content_type, null: false
      t.integer :content_size

      t.references :archive_category, null: true, index: true

      t.timestamps null: false
    end
  end
end
