class AddSignerNameAndSignerEmailToSigns < ActiveRecord::Migration[5.0]
  def change
    add_column :signs, :signer_name, :string, null: true
    add_column :signs, :signer_email, :string, null: true
    add_index :signs, [:petition_id, :signer_email], unique: true
  end
end
