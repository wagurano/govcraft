class AddPublishedAtToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :published_at, :datetime
    reversible do |dir|
      dir.up do
        transaction do
          Story.all.each do |story|
            story.update_columns(published_at: story.created_at)
          end
        end
        change_column_null :stories, :published_at, false
      end
    end
  end
end
