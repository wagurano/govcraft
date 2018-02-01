class CreateAgencies < ActiveRecord::Migration[5.0]
  def change
    create_table :agencies do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.timestamps null: false
    end
  end
end
