class AddEventAttributesToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :slug, :string, unique: true
    add_column :petitions, :comments_count, :integer, default: 0
    add_column :petitions, :template, :string, default: 'petition', null: :false
    add_column :petitions, :title_to_agent, :string
    add_column :petitions, :message_to_agent, :text
  end
end
