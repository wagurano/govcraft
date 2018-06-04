class CreateVoteawardComments < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_comments do |t|
      t.string :content
      t.string :oid, :null => false
      t.string :commentable_type
      t.belongs_to :commentable
      t.belongs_to :voteaward_user
      t.timestamps
    end

    add_index :voteaward_comments, [:oid], name: 'idx_voteaward_comments_oid'
  end

  def self.down
    drop_table :voteaward_comments
  end
end
