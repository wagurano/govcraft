class AddGoogleAccessTokenAndGoogleRefreshTokenOfBulkTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :bulk_tasks, :google_access_token, :string
    add_column :bulk_tasks, :google_refresh_token, :string
  end
end
