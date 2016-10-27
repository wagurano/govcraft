class AddLikesCountToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :likes_count, :integer, default: 0
  end
end
