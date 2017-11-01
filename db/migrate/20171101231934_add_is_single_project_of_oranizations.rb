class AddIsSingleProjectOfOranizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :single_project_slug, :string
  end
end
