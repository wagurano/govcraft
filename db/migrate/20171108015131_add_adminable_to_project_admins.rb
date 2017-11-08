class AddAdminableToProjectAdmins < ActiveRecord::Migration[5.0]
  def change
    add_reference :project_admins, :adminable, polymorphic: true

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE project_admins
               SET adminable_type = 'Project',
                   adminable_id = project_id;
          SQL
        end
        change_column_null :project_admins, :adminable_type, false
        change_column_null :project_admins, :adminable_id, false
      end
    end

    remove_column :project_admins, :project_id

    add_index :project_admins, [:user_id, :adminable_id, :adminable_type], unique: true, name: 'index_project_admins_on_user_and_adminable'
    remove_index :project_admins, name: 'index_project_admins_on_user_id_and_project_id'
  end
end
