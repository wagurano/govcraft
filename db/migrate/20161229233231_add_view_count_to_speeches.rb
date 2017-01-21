class AddViewCountToSpeeches < ActiveRecord::Migration[5.0]
  def change
    add_column :speeches, :cached_view_count, :integer, default: 0
    add_column :speeches, :view_count_cached_at, :datetime
    add_column :speeches, :is_expired_view_count, :boolean, default: false
  end
end
