class AddSiteAndRegionToSpeakers < ActiveRecord::Migration[5.0]
  def change
    add_column :speakers, :public_site, :string
    add_column :speakers, :election_region, :string
  end
end
