class CreateCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :candidates do |t|
      t.string :name, null: false
      t.text :body
      t.string :image
      t.references :election, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
