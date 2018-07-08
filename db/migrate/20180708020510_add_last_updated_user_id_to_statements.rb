class AddLastUpdatedUserIdToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :last_updated_user_id, :integer
  end
end
