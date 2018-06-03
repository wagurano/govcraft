class CreateVoteawardPromises < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_promises do |t|
      t.integer :age
      t.string :area
      t.string :award_ids # Array
      t.integer :likes
      t.string :reason
      t.integer :seq
      t.string :sex
      t.boolean :show_candidate
      t.string :oid, :null => false
      t.belongs_to :voteaward_election
      t.belongs_to :voteaward_candidate
      t.belongs_to :voteaward_user
      t.timestamps
    end

    add_index :voteaward_promises, [:oid], name: 'idx_voteaward_promises_oid'
  end

  def self.down
    drop_table :voteaward_promises
  end
end
