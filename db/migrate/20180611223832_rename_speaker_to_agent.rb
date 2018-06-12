class RenameSpeakerToAgent < ActiveRecord::Migration[5.0]
  def change
    rename_column :agenda_documents, :speaker_id, :agent_id
    rename_column :assembly_members, :speaker_id, :agent_id
    rename_column :comments, :target_speaker_id, :target_agent_id
    rename_table :comments_target_speakers, :comments_target_agents
    rename_column :comments_target_agents, :speaker_id, :agent_id
    rename_column :election_candidates, :speaker_id, :agent_id
    rename_column :events, :title_to_speaker, :title_to_agent
    rename_column :events, :message_to_speaker, :message_to_agent
    rename_column :events_speakers, :speaker_id, :agent_id
    rename_column :opinions, :speaker_id, :agent_id
    rename_column :petitions, :speaker_section_title, :agent_section_title
    rename_column :petitions, :speaker_section_response_title, :agent_section_response_title
    rename_table :petitions_speakers, :agents_petitions
    rename_column :agents_petitions, :speaker_id, :agent_id
    rename_column :sent_requests, :speaker_id, :agent_id
    rename_table :speakers, :agents
    rename_column :statements, :speaker_id, :agent_id

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE taggings SET taggable_type = 'Agent' WHERE taggable_type = 'Speaker'
          SQL
        end
      end

      dir.down do
        transaction do
          execute <<-SQL
            UPDATE taggings SET taggable_type = 'Speaker' WHERE taggable_type = 'Agent'
          SQL
        end
      end
    end
  end
end
