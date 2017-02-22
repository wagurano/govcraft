class AddDescToArchiveCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :archive_categories, :desc, :text
  end
end
