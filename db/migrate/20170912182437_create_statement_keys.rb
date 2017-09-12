class CreateStatementKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :statement_keys do |t|
      t.belongs_to :statement, null: false, index: true
      t.string :key, null: false, index: true
      t.datetime :expired_at, null: false
      t.timestamps null: false
    end
  end
end
