class CreateAppointment < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.references :position, index: true, null: false
      t.references :agent, index: true, null: false
      t.date :started_at
      t.date :ended_at
      t.timestamps null: false
    end
  end
end
