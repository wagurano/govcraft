class AddEventEnabledToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :event_enabled, :boolean, default: true
  end
end
