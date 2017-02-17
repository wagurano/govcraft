class AddMoreFieldsToArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    remove_column :archive_documents, :is_secret_content_source, :boolean
    remove_column :archive_documents, :content_created_date, :boolean
    remove_column :archive_documents, :archive_category_id, :boolean

    add_column :archive_documents, :media_type, :string
    add_column :archive_documents, :content_created_date, :string
    add_column :archive_documents, :content_recipients, :string
    add_column :archive_documents, :donor, :string
    add_column :archive_documents, :is_secret_donor, :boolean

    ArchiveDocument.update_all(media_type: '문서')
    change_column_null :archive_documents, :media_type, false
  end
end
