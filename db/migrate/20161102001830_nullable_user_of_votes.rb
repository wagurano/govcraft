class NullableUserOfVotes < ActiveRecord::Migration[5.0]
  def change
    change_column_null :votes, :user_id, true
  end
end
