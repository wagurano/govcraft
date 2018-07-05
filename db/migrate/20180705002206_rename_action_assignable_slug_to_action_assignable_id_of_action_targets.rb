class RenameActionAssignableSlugToActionAssignableIdOfActionTargets < ActiveRecord::Migration[5.0]
  def change
    rename_column :action_targets, :action_assignable_slug, :action_assignable_id
  end
end
