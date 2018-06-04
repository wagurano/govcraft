class CreateVoteawardAwards < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_awards do |t|
      t.string :title
      t.text :prize
      t.text :content
      t.string :address
      t.string :promise_ids # Array
      t.string :oid, :null => false
      t.belongs_to :voteaward_election
      t.belongs_to :voteaward_user
      t.timestamps
    end

    add_index :voteaward_awards, [:oid], name: 'idx_voteaward_awards_oid'
  end

  def self.down
    drop_table :voteaward_awards
  end
end
