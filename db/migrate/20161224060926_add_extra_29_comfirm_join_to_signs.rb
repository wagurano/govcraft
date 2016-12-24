class AddExtra29ComfirmJoinToSigns < ActiveRecord::Migration[5.0]
  def change
    add_column :signs, :extra_29_confirm_join, :boolean, default: false
  end
end
