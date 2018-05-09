class CreateAreas < ActiveRecord::Migration[5.0]
  def change
    create_table :areas do |t|
      t.string :code, null: false, index: true, uniq: true
      t.string :division, null: false
      t.string :subdivision
      t.string :neighborhood
      t.timestamps null: false
    end
  end
end
