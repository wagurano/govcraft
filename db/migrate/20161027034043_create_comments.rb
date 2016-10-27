class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user, index: true, null: false
      t.references :commentable, index: true, null: false, polymorphic: true
      t.text :body
      t.timestamps null: false
    end
  end
end
