class MigrateStatementableOfCampaigns < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE statements
               SET statementable_type = 'Campaign'
             WHERE statementable_type = 'Petition'
          SQL
          execute <<-SQL
            UPDATE action_targets
               SET action_targetable_type = 'Campaign'
             WHERE action_targetable_type = 'Petition'
          SQL
        end
      end

      dir.down do
        transaction do
          execute <<-SQL
            UPDATE statements
               SET statementable_type = 'Petition'
             WHERE statementable_type = 'Campaign'
          SQL
          execute <<-SQL
            UPDATE action_targets
               SET action_targetable_type = 'Petition'
             WHERE action_targetable_type = 'Campaign'
          SQL
        end
      end
    end
  end
end
