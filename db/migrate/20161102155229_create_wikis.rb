class CreateWikis < ActiveRecord::Migration[5.0]
  def change
    create_table :wikis do |t|
      t.string :title
      t.text :body
      t.references :user, index: true, null: false
      t.references :campaign, index: true, null: false
      t.integer :views_count, default: 0
      t.integer :comments_count, default: 0
      t.integer :likes_count, default: 0

      t.timestamps
    end
  end
end
