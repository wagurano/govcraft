class AddAgendaToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_reference :petitions, :agenda, index: true, null: true
  end
end
