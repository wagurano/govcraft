class ChangeProjectAdminsToAdmins < ActiveRecord::Migration[5.0]
  def change
    rename_table :project_admins, :admins
  end
end
