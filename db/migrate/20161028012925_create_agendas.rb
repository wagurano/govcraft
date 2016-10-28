class CreateAgendas < ActiveRecord::Migration[5.0]
  def change
    create_table :agendas do |t|
      t.references :user, index: true
      t.text :problem
      t.text :solution
      t.text :memo
      t.string :image
      t.integer :comments_count, default: 0
      t.integer :likes_count, default: 0

      t.timestamps
    end
  end
end
