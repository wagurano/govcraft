class AddToSiteNameToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :site_name, :string
  end
end
