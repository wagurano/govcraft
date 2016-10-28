class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, index: true
      t.references :poll, null: false, index: true
      t.string :choice
      t.timestamps null: false
    end

    add_index :votes, %w(user_id poll_id), unique: true
  end
end
