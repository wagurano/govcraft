class AddMediaToArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :archive_documents, :media_url, :string
    add_column :archive_documents, :media_credit, :string
  end
end
