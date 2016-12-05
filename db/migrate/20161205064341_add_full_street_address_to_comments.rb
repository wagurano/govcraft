class AddFullStreetAddressToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :full_street_address, :string
  end
end
