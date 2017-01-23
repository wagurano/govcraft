class AddSubtitleToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :subtitle, :string
  end
end
