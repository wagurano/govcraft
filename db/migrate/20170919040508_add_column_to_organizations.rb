class AddColumnToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :slogan, :string
  end
end
