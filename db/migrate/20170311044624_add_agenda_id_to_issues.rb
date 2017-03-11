class AddAgendaIdToIssues < ActiveRecord::Migration[5.0]
  def change
    add_reference :issues, :agenda
  end
end
