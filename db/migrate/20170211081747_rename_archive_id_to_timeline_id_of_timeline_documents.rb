class RenameArchiveIdToTimelineIdOfTimelineDocuments < ActiveRecord::Migration[5.0]
  def change
    rename_column :timeline_documents, :archive_id, :timeline_id
  end
end
