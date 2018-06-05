class CreateAgendasIssues < ActiveRecord::Migration[5.0]
  def up
    create_table :agendas_issues do |t|
      t.belongs_to :agenda, index: true
      t.belongs_to :issue, index: true
    end

    rename_column :issues, :agenda_id, :deprecated_agenda_id

    transaction do
      execute <<-SQL
        INSERT
          INTO agendas_issues(agenda_id, issue_id)
        SELECT deprecated_agenda_id, id
          FROM issues
      SQL
    end
  end

  def down
    transaction do
      execute <<-SQL
        UPDATE issues
           SET deprecated_agenda_id = (SELECT agenda_id FROM agendas_issues WHERE agendas_issues.issue_id = issues.id LIMIT 1)
      SQL
    end

    drop_table :agendas_issues
    rename_column :issues, :deprecated_agenda_id, :agenda_id
  end
end
