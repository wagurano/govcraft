class AddAgendaThemeToIssue < ActiveRecord::Migration[5.0]
  def change
    add_reference :issues, :agenda_theme, null: true, index: true
  end
end
