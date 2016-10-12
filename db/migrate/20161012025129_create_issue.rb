class CreateIssue < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      t.string :title, null: false
      t.integer :following_issues_count, default: 0
      t.timestamps null: false
    end

    add_index :issues, :title, unique: true
  end
end
