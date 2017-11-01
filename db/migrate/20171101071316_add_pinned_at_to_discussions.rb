class AddPinnedAtToDiscussions < ActiveRecord::Migration[5.0]
  def change
    add_column :discussions, :pinned_at, :datetime
  end
end
