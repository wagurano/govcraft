class AddLikesCountToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :likes_count, :integer, default: 0
  end
end
