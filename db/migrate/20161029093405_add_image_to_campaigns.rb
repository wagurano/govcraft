class AddImageToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :image, :string
  end
end
