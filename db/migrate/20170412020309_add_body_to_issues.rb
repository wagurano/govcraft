class AddBodyToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :body, :text
  end
end
