class AddViewsCounts < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :views_count, :integer, default: 0
    add_column :discussions, :views_count, :integer, default: 0
    add_column :petitions, :views_count, :integer, default: 0
    add_column :polls, :views_count, :integer, default: 0
  end
end
