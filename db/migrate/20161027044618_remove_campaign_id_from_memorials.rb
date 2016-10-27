class RemoveCampaignIdFromMemorials < ActiveRecord::Migration[5.0]
  def change
    remove_column :memorials, :campaign_id, :string
  end
end
