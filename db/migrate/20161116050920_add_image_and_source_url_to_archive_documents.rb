class AddImageAndSourceUrlToArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :archive_documents, :image, :string
    add_column :archive_documents, :source_url, :string
  end
end
