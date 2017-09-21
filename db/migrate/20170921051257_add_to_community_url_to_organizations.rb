class AddToCommunityUrlToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :community_url, :string
  end
end
