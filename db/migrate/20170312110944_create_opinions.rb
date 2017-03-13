class CreateOpinions < ActiveRecord::Migration[5.0]
  def change
    create_table :opinions do |t|
      t.string :quote
      t.text :body
      t.references :speaker
      t.references :issue

      t.timestamps
    end
  end
end
