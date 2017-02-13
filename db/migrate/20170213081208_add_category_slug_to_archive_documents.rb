class AddCategorySlugToArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :archive_documents, :category_slug, :string, index: true
  end
end
