class AddStanceToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :has_stance, :boolean, default: false
    add_column :opinions, :stance, :string, index: true
  end
end
