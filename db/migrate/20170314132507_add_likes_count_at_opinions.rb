class AddLikesCountAtOpinions < ActiveRecord::Migration[5.0]
  def change
    add_column :opinions, :likes_count, :integer, default: 0
    add_column :opinions, :anonymous_likes_count, :integer, default: 0
  end
end
