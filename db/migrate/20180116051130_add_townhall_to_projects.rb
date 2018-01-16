class AddTownhallToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :townhall_enabled, :boolean, default: true
    add_column :projects, :townhall_title, :string
    add_column :projects, :townhall_sequence, :integer
  end
end
