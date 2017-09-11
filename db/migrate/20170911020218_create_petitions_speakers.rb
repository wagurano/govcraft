class CreatePetitionsSpeakers < ActiveRecord::Migration[5.0]
  def change
    create_table :petitions_speakers do |t|
      t.belongs_to :petition, index: true
      t.belongs_to :speaker, index: true
      t.timestamps null: false
    end

    add_index :petitions_speakers, [:petition_id, :speaker_id], unique: true
  end
end
