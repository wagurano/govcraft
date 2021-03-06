class MigratePressEventsToPetitions < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          DeprecatedEvent.where(template: 'press').each do |event|
            petition = Petition.new(previous_event_id: event.id,
              slug: event.slug, title: event.title, body: event.body,
              user_id: event.user_id, comments_count: event.comments_count,
              created_at: event.created_at, updated_at: event.updated_at,
              project_id: event.project_id, template: 'order',
              css: event.css, social_image: event.read_attribute(:social_image),
              title_to_agent: event.title_to_agent,
              message_to_agent: event.message_to_agent,
              closed_at: event.closed_at)
            petition.remote_cover_image_url = event.image_url if event.read_attribute(:image).present?
            petition.save!
            event.comments.update_all(commentable_type: 'Petition', commentable_id: petition.id)
            event.statements.update_all(statementable_type: 'Petition', statementable_id: petition.id)
            execute <<-SQL
              INSERT INTO agents_petitions(petition_id, agent_id, created_at, updated_at)
                   SELECT #{petition.id}, deprecated_agents_events.agent_id, created_at, updated_at
                     FROM deprecated_agents_events
                    WHERE deprecated_agents_events.deprecated_event_id = #{event.id}
            SQL
            event.action_targets.update_all(action_targetable_type: 'Petition', action_targetable_id: petition.id)
          end
        end
      end

      dir.down do
        transaction do
          execute <<-SQL
            UPDATE comments
               SET commentable_id = previous_event_id,
                   commentable_type = 'Event'
             WHERE commentable_type = 'Petition'
               AND commentable_id in (
                SELECT id
                  FROM petitions
                 WHERE template = 'order'
               )
          SQL
          execute <<-SQL
            UPDATE statements
               SET statementable_id = previous_event_id,
                   statementable_type = 'Event'
             WHERE statementable_type = 'Petition'
               AND statementable_id in (
                SELECT id
                  FROM petitions
                 WHERE template = 'order'
               )
          SQL
          execute <<-SQL
            UPDATE action_targets
               SET action_targetable_id = previous_event_id,
                   action_targetable_type = 'Event'
             WHERE action_targetable_type = 'Petition'
               AND action_targetable_id in (
                SELECT id
                  FROM petitions
                 WHERE template = 'order'
               )
          SQL
          execute <<-SQL
            DELETE FROM agents_petitions
             WHERE petition_id in (
              SELECT id
                FROM petitions
               WHERE template = 'order'
             )
          SQL
          execute <<-SQL
            DELETE FROM petitions
             WHERE template = 'order'
          SQL
        end
      end
    end
  end
end
