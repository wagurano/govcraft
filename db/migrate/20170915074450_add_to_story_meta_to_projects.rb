class AddToStoryMetaToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :story_enabled, :boolean, default: true
    add_column :projects, :story_title, :string
    add_column :projects, :story_sequence, :integer, default: 0
  end
end
