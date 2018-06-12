class RenameEventsSpeakersToAgentsEvents < ActiveRecord::Migration[5.0]
  def change
    rename_table :events_speakers, :agents_events
  end
end
