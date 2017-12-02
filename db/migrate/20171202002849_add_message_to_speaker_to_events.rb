class AddMessageToSpeakerToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :title_to_speaker, :string
    add_column :events, :message_to_speaker, :text
  end
end
