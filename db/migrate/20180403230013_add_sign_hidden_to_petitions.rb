class AddSignHiddenToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :sign_hidden, :boolean, default: false, null: false
  end
end
