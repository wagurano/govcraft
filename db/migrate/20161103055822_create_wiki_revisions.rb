class CreateWikiRevisions < ActiveRecord::Migration[5.0]
  def change
    create_table :wiki_revisions do |t|
      t.references :wiki, null: false, index: true
      t.references :user, null: false, index: true
      t.text :body
      t.text :note
      t.timestamps null: false
    end
  end
end
