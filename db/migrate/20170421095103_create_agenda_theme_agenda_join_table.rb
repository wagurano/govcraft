class CreateAgendaThemeAgendaJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :agenda_themes_agendas, id: false , options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.integer :agenda_theme_id
      t.integer :agenda_id
      t.index [:agenda_theme_id, :agenda_id], unique: true
    end
  end
end
