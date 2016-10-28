class CreateArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :archive_documents do |t|
      t.string :title
      t.text :body
      t.date :date
      t.string :time
      t.references :user, index: true, null: false
      t.references :archive, index: true, null: false
      t.integer :comments_count, default: 0
      t.integer :likes_count, default: 0

      t.timestamps
    end
  end
end
