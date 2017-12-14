class AddConfirmPrivacyAtPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :confirm_privacy, :text
  end
end
