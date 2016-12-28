class CreateCitizen2017Speeches < ActiveRecord::Migration[5.0]
  def change
    create_table :citizen2017_speeches, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC"  do |t|
      t.string :title
      t.integer :citizen2017_id
      t.string :video_url
    end
  end
end
