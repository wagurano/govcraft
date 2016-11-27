class AddCampaignIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :campaign
  end
end
