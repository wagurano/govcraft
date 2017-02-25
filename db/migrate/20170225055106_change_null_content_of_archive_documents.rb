class ChangeNullContentOfArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    change_column_null :archive_documents, :content, :true
    change_column_null :archive_documents, :content_name, :true
    change_column_null :archive_documents, :content_size, :true
    change_column_null :archive_documents, :content_type, :true
  end
end
