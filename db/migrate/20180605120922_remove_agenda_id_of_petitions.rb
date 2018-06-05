class RemoveAgendaIdOfPetitions < ActiveRecord::Migration[5.0]
  def change
    remove_column :petitions, :agenda_id
  end
end
