class AddImageToAgencies < ActiveRecord::Migration[5.0]
  def change
    add_column :agencies, :image, :string
  end
end
