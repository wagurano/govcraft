class AddUseSignerColumnsAtPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :use_signer_real_name, :boolean, default: false
    add_column :petitions, :use_signer_email, :boolean, default: false
    add_column :petitions, :use_signer_address, :boolean, default: false

    add_column :petitions, :signer_real_name_title, :string
    add_column :petitions, :signer_email_title, :string
    add_column :petitions, :signer_address_title, :string
  end
end
