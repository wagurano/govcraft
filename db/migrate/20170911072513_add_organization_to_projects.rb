class AddOrganizationToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :organization, index: true, null: true
  end
end
