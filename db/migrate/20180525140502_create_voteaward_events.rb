class CreateVoteawardEvents < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_events do |t|
      t.string :title
      t.text :content
      t.string :address
      t.json :coordinates
      t.string :image_filename
      t.integer :likes
      t.integer :limit
      t.string :oid, :null => false
      t.belongs_to :voteaward_election
      t.belongs_to :voteaward_user
      t.timestamps
    end

    add_index :voteaward_events, [:oid], name: 'idx_voteaward_events_oid'
  end

  def self.down
    drop_table :voteaward_events
  end
end
