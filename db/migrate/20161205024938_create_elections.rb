class CreateElections < ActiveRecord::Migration[5.0]
  def change
    create_table :elections do |t|
      t.string :title
      t.text :body
      t.string :image
      t.references :user, index: true, null: false
      t.references :campaign, index: true
      t.datetime :registered_from, null: false
      t.datetime :registered_to, null: false
      t.datetime :voted_from, null: false
      t.datetime :voted_to, null: false

      t.timestamps null: false
    end
  end
end
