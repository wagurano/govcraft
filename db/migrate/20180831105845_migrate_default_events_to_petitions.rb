class MigrateDefaultEventsToPetitions < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          DeprecatedEvent.where(template: 'default').each do |event|
            petition = Petition.new(previous_event_id: event.id,
              slug: event.slug, title: event.title, body: event.body,
              user_id: event.user_id, comments_count: event.comments_count,
              created_at: event.created_at, updated_at: event.updated_at,
              project_id: event.project_id, template: 'basic',
              css: event.css, social_image: event.read_attribute(:social_image),
              title_to_agent: event.title_to_agent,
              message_to_agent: event.message_to_agent,
              closed_at: event.closed_at)
            petition.remote_cover_image_url = event.image_url if event.read_attribute(:image).present?
            petition.save!
            event.comments.update_all(commentable_type: 'Petition', commentable_id: petition.id)
          end
        end
      end

      dir.down do
        transaction do
          Petition.where('event')

          execute <<-SQL
            UPDATE comments
               SET commentable_id = previous_event_id,
                   commentable_type = 'Event'
             WHERE commentable_type = 'Petition'
               AND commentable_id in (
                SELECT id
                  FROM petitions
                 WHERE template = 'basic'
               )
          SQL

          execute <<-SQL
            DELETE FROM petitions
             WHERE template = 'basic'
          SQL

        end
      end
    end
  end
end
