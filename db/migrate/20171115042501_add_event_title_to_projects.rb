class AddEventTitleToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :event_title, :string
  end
end
