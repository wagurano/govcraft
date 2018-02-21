class AddSignerPhoneToSigns < ActiveRecord::Migration[5.0]
  def change
    add_column :signs, :signer_phone, :string
  end
end
