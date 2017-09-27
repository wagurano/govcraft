class AddColumnToNposAddtionalArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :npos_addtional_archive_documents, :fax, :string
    add_column :npos_addtional_archive_documents, :sub_region, :string
  end
end
