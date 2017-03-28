class AddDescToOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :options, :desc, :string
  end
end
