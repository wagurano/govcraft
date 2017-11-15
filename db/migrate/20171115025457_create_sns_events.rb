class CreateSnsEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :sns_events do |t|
      t.string :facebook_hashtags
      t.string :facebook_href
      t.text :tweet
      t.references :event, null: false, index: true
      t.timestamps null: false
    end
  end
end
