class CreateVoteawardVotes < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_votes do |t|
      t.string :title
      t.text :content
      t.json :coordinates
      t.string :image_filename
      t.integer :likes
      t.integer :seq
      t.string :oid, :null => false
      t.belongs_to :voteaward_event
      t.belongs_to :voteaward_election
      t.belongs_to :voteaward_user
      t.timestamps
    end

    add_index :voteaward_votes, [:oid], name: 'idx_voteaward_votes_oid'
  end

  def self.down
    drop_table :voteaward_votes
  end
end
