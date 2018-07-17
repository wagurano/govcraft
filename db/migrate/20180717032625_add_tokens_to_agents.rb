class AddTokensToAgents < ActiveRecord::Migration[5.0]
  def change
    add_column :agents, :access_token, :string
    add_column :agents, :access_fail_count, :integer, default: 0
    add_column :agents, :refresh_access_token, :string
    add_column :agents, :refresh_access_token_at, :datetime
  end
end
