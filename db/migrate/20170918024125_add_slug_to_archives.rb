class AddSlugToArchives < ActiveRecord::Migration[5.0]
  def change
    add_column :archives, :slug, :string
  end
end
