class DeprecateEventTitleOfProjects < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :event_title, :deprecated_event_title
    rename_column :projects, :event_sequence, :deprecated_event_sequence
  end
end
