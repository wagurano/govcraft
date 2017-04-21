class CreateAgendaThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :agenda_themes, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.string :title, null: false
      t.text :body
      t.string :slug, null: false, index: true, unique: true
      t.references :project, null: true
      t.string :cover
      t.timestamps null: false
    end
  end
end
