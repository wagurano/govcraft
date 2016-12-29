class AddSpeechToCitizen2017Speeches < ActiveRecord::Migration[5.0]
  def change
    add_reference :citizen2017_speeches, :speech, index: true
  end
end
