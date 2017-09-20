class ChangeNullOfSewolAttributesOnArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    change_column_null :archive_documents, :media_type, true
  end
end
