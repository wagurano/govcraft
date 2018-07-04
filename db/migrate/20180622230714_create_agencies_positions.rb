class CreateAgenciesPositions < ActiveRecord::Migration[5.0]
  def change
    create_table :agencies_positions do |t|
      t.references :agency, null: false
      t.references :position, null: false
    end

    add_index :agencies_positions, [:agency_id, :position_id], unique: true
  end
end
