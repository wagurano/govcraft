class CreateSentRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :sent_requests do |t|
      t.references :speaker, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps null: false
    end

    add_column :speakers, :sent_requests_count, :integer, default: 0
  end
end
