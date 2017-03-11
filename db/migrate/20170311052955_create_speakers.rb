class CreateSpeakers < ActiveRecord::Migration[5.0]
  def change
    create_table :speakers do |t|
      t.string :name, null: false
      t.string :organization
      t.string :category, null: false
      t.string :image
    end
  end
end
