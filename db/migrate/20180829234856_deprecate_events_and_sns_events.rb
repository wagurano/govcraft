class DeprecateEventsAndSnsEvents < ActiveRecord::Migration[5.0]
  def change
    rename_table :events, :deprecated_events
    rename_table :sns_events, :deprecated_sns_events

    rename_column :projects, :event_enabled, :deprecated_event_enabled

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE projects
               SET petition_enabled = 1
             WHERE deprecated_event_enabled = 1
          SQL

          execute <<-SQL
            UPDATE comments
               SET commentable_type = 'DeprecatedEvent'
             WHERE commentable_type = 'Event'
          SQL
        end
      end
    end

    rename_table :agents_events, :deprecated_agents_events
    rename_column :deprecated_sns_events, :event_id, :deprecated_event_id
    remove_index :deprecated_agents_events, name: :index_deprecated_agents_events_on_event_id
    remove_index :deprecated_agents_events, name: :index_deprecated_agents_events_on_event_id_and_agent_id
    rename_column :deprecated_agents_events, :event_id, :deprecated_event_id
  end
end
