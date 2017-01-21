class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, index: true
      t.references :project, index: true
      t.integer :likes_count, default: 0
      t.integer :anonymous_likes_count, default: 0
      t.integer :feedbacks_count, default: 0, null: false
      t.integer :views_count, default: 0, null: false
      t.integer :duration, default: 0, null: false
      t.string :cover_image
      t.string :social_card
      t.timestamps null: false
    end
  end
end
