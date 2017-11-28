class AddSocialImageToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :social_image, :string
  end
end
