class AddTownhallIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :townhall_id, :integer
  end
end
