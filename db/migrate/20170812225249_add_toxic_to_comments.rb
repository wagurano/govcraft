class AddToxicToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :toxic, :boolean, default: false
  end
end
