class AddTemplateToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :template, :string
  end
end
