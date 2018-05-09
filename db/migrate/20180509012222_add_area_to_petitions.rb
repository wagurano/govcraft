class AddAreaToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_reference :petitions, :area, index: true, null: true
  end
end
