class AddSnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :site_info, :string
    add_column :users, :facebook_info, :string
    add_column :users, :twitter_info, :string
  end
end
