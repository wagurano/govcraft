class AddSignerAddressAtSigns < ActiveRecord::Migration[5.0]
  def change
    add_column :signs, :signer_real_name, :string
    add_column :signs, :signer_address, :string
  end
end
