class AddCoverImageToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :cover_image, :string
  end
end
