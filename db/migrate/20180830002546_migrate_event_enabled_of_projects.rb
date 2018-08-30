class MigrateEventEnabledOfProjects < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :event_enabled, :deprecated_event_enabled

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE projects
               SET petition_enabled = 1
             WHERE deprecated_event_enabled = 1
          SQL
        end
      end
    end
  end
end
