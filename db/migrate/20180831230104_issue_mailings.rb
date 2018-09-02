class IssueMailings < ActiveRecord::Migration[5.0]
  def change
    create_table :issue_mailings do |t|
      t.references :issue
      t.references :source, polymorphic: true
      t.string :action, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
