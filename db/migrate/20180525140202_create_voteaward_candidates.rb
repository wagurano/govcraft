class CreateVoteawardCandidates < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_candidates do |t|
      t.string :name
      t.string :number
      t.string :party
      t.string :oid, :null => false
      t.belongs_to :voteaward_election
      t.timestamps
    end

    add_index :voteaward_candidates, [:oid], name: 'idx_voteaward_candidates_oid'
  end

  def self.down
    drop_table :voteaward_candidates
  end
end
