class CreateVoteawardGiveups < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_giveups do |t|
      t.integer :age
      t.string :area
      t.string :reason
      t.string :sex
      t.string :oid, :null => false
      t.belongs_to :voteaward_user
      t.timestamps
    end

    add_index :voteaward_giveups, [:oid], name: 'idx_voteaward_giveups_oid'
  end

  def self.down
    drop_table :voteaward_giveups
  end
end
