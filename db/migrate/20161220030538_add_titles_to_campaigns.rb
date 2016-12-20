class AddTitlesToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :discussion_title, :string
    add_column :campaigns, :poll_title, :string
    add_column :campaigns, :petition_title, :string
    add_column :campaigns, :wiki_title, :string
  end
end
