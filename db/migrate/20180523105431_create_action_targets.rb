class CreateActionTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :action_targets do |t|
      t.string :action_assignable_slug, null: false
      t.string :action_assignable_type, null: false
      t.references :action_targetable, polymorphic: true, index: false
    end

    add_index :action_targets, [:action_assignable_slug, :action_assignable_type, :action_targetable_type, :action_targetable_id], unique: true, name: 'action_target_unique'
  end
end
