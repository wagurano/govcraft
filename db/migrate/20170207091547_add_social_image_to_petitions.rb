class AddSocialImageToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :social_image, :string
  end
end
