class CreateMemorials < ActiveRecord::Migration[5.0]
  def change
    create_table :memorials do |t|
      t.string :title
      t.text :body
      t.references :campaign
      t.references :user

      t.timestamps
    end
  end
end
