class CreateRaces < ActiveRecord::Migration[5.0]
  def change
    create_table :races do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, null: false
      t.timestamps null: false
    end
  end
end
