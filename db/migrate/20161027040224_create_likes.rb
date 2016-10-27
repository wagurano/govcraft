class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :user, index: true, null: false
      t.references :likable, index: true, null: false, polymorphic: true
      t.timestamps null: false
    end
  end
end
