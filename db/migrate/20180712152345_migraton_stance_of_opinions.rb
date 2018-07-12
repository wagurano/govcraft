class MigratonStanceOfOpinions < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE opinions
               SET stance = 'unsure'
             WHERE stance = 'unsuer'
          SQL
        end
      end

      dir.down do
        transaction do
          execute <<-SQL
            UPDATE opinions
               SET stance = 'unsuer'
             WHERE stance = 'unsure'
          SQL
        end
      end
    end
  end
end
