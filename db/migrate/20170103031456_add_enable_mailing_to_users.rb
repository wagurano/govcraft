class AddEnableMailingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :enable_mailing, :boolean, default: true
  end
end
