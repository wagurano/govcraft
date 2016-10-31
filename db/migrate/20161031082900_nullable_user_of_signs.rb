class NullableUserOfSigns < ActiveRecord::Migration[5.0]
  def up
    change_column_null :signs, :user_id, true
  end
end
