class MigratePetitionOfSpeeches < ActiveRecord::Migration[5.0]
  def change
    add_reference :speeches, :petition, index: true
    rename_column :speeches, :event_id, :deprecated_event_id

    reversible do |dir|
      dir.up do
        transaction do
          Petition.where(template: 'special_speech').each do |petition|
            Speech.where(deprecated_event_id: petition.previous_event_id).update_all(petition_id: petition.id)
          end
        end
      end
    end

    change_column_null :speeches, :petition_id, false
  end
end
