class AddLikesCountToMemorials < ActiveRecord::Migration[5.0]
  def change
    add_column :memorials, :likes_count, :integer, default: 0
  end
end
