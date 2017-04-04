class AddCssToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :css, :text
  end
end
