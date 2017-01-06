class RenameCampaignsToProjects < ActiveRecord::Migration[5.0]
  class DBCampaings < ActiveRecord::Base
  end

  def change
    rename_table :campaigns, :projects

    %i(discussions elections events petitions polls wikis).each do |table_name|
      rename_column table_name, :campaign_id, :project_id
    end
  end
end
