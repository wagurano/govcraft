class AddToSpeakerToComments < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :target_speaker, index: true, null: true
    add_column :comments, :mailing, :string, index: true, deault: 'disable', null: false
  end
end
