class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.references :reportable, polymorphic: true, null: false, index: true
      t.references :user, null: false, index: true
      t.timestamps null: false
      t.index [:reportable_id, :reportable_type, :user_id], unique: true
    end
  end
end
