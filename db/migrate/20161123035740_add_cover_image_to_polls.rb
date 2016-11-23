class AddCoverImageToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :cover_image, :string
  end
end
