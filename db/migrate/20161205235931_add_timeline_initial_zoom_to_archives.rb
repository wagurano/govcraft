class AddTimelineInitialZoomToArchives < ActiveRecord::Migration[5.0]
  def change
    add_column :archives, :timeline_initial_zoom, :integer
  end
end
