class AddHotScoreToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :hot_score, :integer, default: 0
    add_column :articles, :hot_scored_datestamp, :string, index: true
  end
end
