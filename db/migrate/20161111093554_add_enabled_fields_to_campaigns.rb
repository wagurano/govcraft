class AddEnabledFieldsToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :discussion_enabled, :boolean, default: true
    add_column :campaigns, :petition_enabled, :boolean, default: true
    add_column :campaigns, :poll_enabled, :boolean, default: true
    add_column :campaigns, :wiki_enabled, :boolean, default: true
  end
end
