class AddLikesCountAtSpeeches < ActiveRecord::Migration[5.0]
  def change
    add_column :speeches, :likes_count, :integer, default: 0
    add_column :speeches, :anonymous_likes_count, :integer, default: 0
  end
end
