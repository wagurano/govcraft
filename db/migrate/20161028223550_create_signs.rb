class CreateSigns < ActiveRecord::Migration[5.0]
  def change
    create_table :signs do |t|
      t.references :user, null: false, index: true
      t.references :petition, null: false, index: true
      t.text :body
      t.timestamps null: false
    end

    add_index :signs, %w(user_id petition_id), unique: true
  end
end
