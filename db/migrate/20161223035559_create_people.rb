class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.text :body
      t.string :image
      t.references :user, null: false, index: true
      t.timestamps null: false
    end
  end
end
