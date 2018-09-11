class RenamePetitionsToCampaigns < ActiveRecord::Migration[5.0]
  def change
    rename_table :agents_petitions, :agents_campaigns
    rename_column :agents_campaigns, :petition_id, :campaign_id
    rename_table :petitions, :campaigns
    rename_column :projects, :petition_enabled, :campaign_enabled
    rename_column :projects, :petition_title, :campaign_title
    rename_column :projects, :petition_sequence, :campaign_sequence
    rename_column :signs, :petition_id, :campaign_id
    rename_column :speeches, :petition_id, :campaign_id

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE comments
               SET commentable_type = 'Campaign'
             WHERE commentable_type = 'Petition'
          SQL
          execute <<-SQL
            UPDATE issue_mailings
               SET source_type = 'Campaign'
             WHERE source_type = 'Petition'
          SQL
        end
      end

      dir.down do
        transaction do
          execute <<-SQL
            UPDATE comments
               SET commentable_type = 'Petition'
             WHERE commentable_type = 'Campaign'
          SQL
          execute <<-SQL
            UPDATE issue_mailings
               SET source_type = 'Petition'
             WHERE source_type = 'Campaign'
          SQL
        end
      end
    end
  end
end
