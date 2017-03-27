class MigratePolymorphicVotes < ActiveRecord::Migration[5.0]

  def up
    ActiveRecord::Base.transaction do
      add_reference :votes, :votable, polymorphic: true, null: false, index: true

      Vote.all.each do |vote|
        vote.update_columns(votable_id: vote.poll_id, votable_type: 'Poll')
      end

      add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
      remove_index :votes, name: :index_votes_on_poll_id
      remove_index :votes, name: :index_votes_on_user_id_and_poll_id

      remove_column :votes, :poll_id

      add_column :opinions, :votes_count, :integer, default: 0
    end
  end

  def down
    raise "unsupport!"
  end
end
