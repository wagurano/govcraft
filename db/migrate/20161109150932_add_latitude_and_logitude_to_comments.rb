class AddLatitudeAndLogitudeToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :latitude, :float
    add_column :comments, :longitude, :float
  end
end
