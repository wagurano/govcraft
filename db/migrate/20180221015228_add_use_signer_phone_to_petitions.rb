class AddUseSignerPhoneToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :use_signer_phone, :boolean, default: false
    add_column :petitions, :signer_phone_title, :string
  end
end
