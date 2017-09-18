class RemoveKeyFromStatements < ActiveRecord::Migration[5.0]
  def change
    remove_column :statements, :key, :string
  end
end
