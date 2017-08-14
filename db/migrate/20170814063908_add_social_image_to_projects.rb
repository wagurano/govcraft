class AddSocialImageToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :social_image, :string
  end
end
