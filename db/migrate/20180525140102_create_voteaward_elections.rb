class CreateVoteawardElections < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_elections do |t|
      t.string :title
      t.string :content
      t.string :oid, :null => false
      t.timestamps
    end

    add_index :voteaward_elections, [:oid], name: 'idx_voteaward_elections_oid'
  end

  def self.down
    drop_table :voteaward_elections
  end
end
