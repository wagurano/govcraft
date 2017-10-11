class AddCategoryToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :project_category, null: true, index: true
  end
end
