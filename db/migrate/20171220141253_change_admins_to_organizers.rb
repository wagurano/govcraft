class ChangeAdminsToOrganizers < ActiveRecord::Migration[5.0]
  def change
    rename_table :admins, :organizers
    rename_column :organizers, :adminable_id, :organizable_id
    rename_column :organizers, :adminable_type, :organizable_type
  end
end
