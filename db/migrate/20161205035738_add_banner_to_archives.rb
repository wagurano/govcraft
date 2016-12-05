class AddBannerToArchives < ActiveRecord::Migration[5.0]
  def change
    add_column :archives, :banner_image, :string
    add_column :archives, :banner_url, :string
  end
end
