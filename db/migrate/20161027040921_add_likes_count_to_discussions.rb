class AddLikesCountToDiscussions < ActiveRecord::Migration[5.0]
  def change
    add_column :discussions, :likes_count, :integer, default: 0
  end
end
