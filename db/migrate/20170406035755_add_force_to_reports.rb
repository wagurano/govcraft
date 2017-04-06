class AddForceToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :force, :boolean
  end
end
