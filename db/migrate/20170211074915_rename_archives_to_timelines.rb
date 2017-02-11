class RenameArchivesToTimelines < ActiveRecord::Migration[5.0]
  def change
    rename_table :archives, :timelines
    rename_table :archive_documents, :timeline_documents
  end
end
