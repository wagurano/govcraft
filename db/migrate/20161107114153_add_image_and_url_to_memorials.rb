class AddImageAndUrlToMemorials < ActiveRecord::Migration[5.0]
  def change
    add_column :memorials, :comments_count, :integer, default: 0
    add_column :memorials, :image, :string
    add_column :memorials, :url, :string
  end
end
