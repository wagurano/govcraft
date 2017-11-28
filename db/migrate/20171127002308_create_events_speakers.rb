class CreateEventsSpeakers < ActiveRecord::Migration[5.0]
  def change
    create_table :events_speakers do |t|
      t.belongs_to :event, index: true
      t.belongs_to :speaker, index: true
      t.timestamps null: false
    end

    add_index :events_speakers, [:event_id, :speaker_id], unique: true
  end
end
