class AddVotesCountsToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :votes_count, :integer, default: 0
    add_column :polls, :agrees_count, :integer, default: 0
    add_column :polls, :disagrees_count, :integer, default: 0
  end
end
