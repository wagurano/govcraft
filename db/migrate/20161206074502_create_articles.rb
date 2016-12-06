class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.text :url, null: false
      t.text :body
      t.string :title
      t.text     :desc
      t.text     :metadata
      t.string   :image
      t.string   :page_type
      t.string   :crawling_status, null: false
      t.datetime :crawled_at
      t.string   :site_name
      t.integer  :image_height, default: 0
      t.integer  :image_width, default: 0
      t.references :user, null: false, index: true
      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0
      t.integer :anonymous_likes_count, default: 0

      t.timestamps null: false
    end
  end
end
