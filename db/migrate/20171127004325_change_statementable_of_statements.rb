class ChangeStatementableOfStatements < ActiveRecord::Migration[5.0]
  def change
    add_reference :statements, :statementable, polymorphic: true, null: true, index: true

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE statements
               SET statementable_type = 'Petition',
                   statementable_id = petition_id
             WHERE petition_id <> null;
          SQL
        end
      end

      dir.down do
        transaction do
          execute ""
          execute <<-SQL
            UPDATE statements
               SET petition_id = statementable_id
             WHERE statementable_id <> null
               AND statementable_type = 'Petition';
          SQL
        end
      end
    end
  end
end
