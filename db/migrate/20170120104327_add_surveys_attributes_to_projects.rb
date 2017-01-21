class AddSurveysAttributesToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :survey_enabled, :boolean, default: true
    add_column :projects, :survey_title, :string
  end
end
