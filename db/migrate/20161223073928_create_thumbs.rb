class CreateThumbs < ActiveRecord::Migration[5.0]
  def change
    create_table :thumbs do |t|
      t.references :user, index: true
      t.references :thumbable, polymorphic: true, index: true
      t.string :direction, null: false
      t.timestamps null: false
      t.index [:user_id, :thumbable_id, :thumbable_type], unique: true
    end
  end
end
