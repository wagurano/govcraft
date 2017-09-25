class AddArchiveDocumentIdToNposAdditionalArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    add_reference :npos_addtional_archive_documents, :archive_document, null: false, index: true
  end
end
