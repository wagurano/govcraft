class DeprecateAgentsEvents < ActiveRecord::Migration[5.0]
  def change
    rename_table :agents_events, :deprecate_agents_events
  end
end
