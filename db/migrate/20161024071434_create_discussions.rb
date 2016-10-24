class CreateDiscussions < ActiveRecord::Migration[5.0]
  def change
    create_table :discussions do |t|
      t.string :title
      t.text :body
      t.references :user
      t.references :campaign

      t.timestamps
    end
  end
end
