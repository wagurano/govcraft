class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :slug
      t.string :title
      t.text :body
      t.string :image
      t.references :user, foreign_key: true
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end
