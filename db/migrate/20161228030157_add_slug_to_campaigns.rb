class AddSlugToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :slug, :string, unique: true

    reversible do |dir|
      dir.up do
        transaction do
          Campaign.all.each do |campaign|
            campaign.update_columns(slug: campaign.id)
          end
        end
        change_column_null :campaigns, :slug, false
      end
    end

  end
end
