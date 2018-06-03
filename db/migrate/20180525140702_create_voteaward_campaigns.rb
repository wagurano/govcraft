class CreateVoteawardCampaigns < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_campaigns do |t|
      t.string :title
      t.string :description
      t.string :image_filename
      t.string :url
      t.string :oid, :null => false
      t.belongs_to :voteaward_candidate
      t.belongs_to :voteaward_user
      t.timestamps
    end

    add_index :voteaward_campaigns, [:oid], name: 'idx_voteaward_campaigns_oid'
  end

  def self.down
    drop_table :voteaward_campaigns
  end
end
