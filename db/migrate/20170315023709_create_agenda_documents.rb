class CreateAgendaDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :agenda_documents, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.references :speaker, null: false, index: true
      t.references :agenda, null: false, index: true
      t.references :user, null: true, index: true
      t.string :attachment, null: false
      t.string :name
      t.string :file_type
      t.string :file_size
      t.text :desc
      t.timestamps null: false
    end
  end
end
