class DeprecateEventsAndSnsEvents < ActiveRecord::Migration[5.0]
  def change
    rename_table :events, :deprecated_events
    rename_table :sns_events, :deprecated_sns_events
  end
end
