class CreateRenewalElections < ActiveRecord::Migration[5.0]
  def change
    create_table :elections do |t|
      t.string :slug, index: true, uniqe: true, null: false
      t.string :title
      t.timestamps null: false
    end
  end
end
