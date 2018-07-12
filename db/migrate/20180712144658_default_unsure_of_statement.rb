class DefaultUnsureOfStatement < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:statements, :stance, 'unsure')

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE statements
               SET stance = 'unsure'
             WHERE stance is null
          SQL
        end
      end

      dir.down do
        transaction do
          execute <<-SQL
            UPDATE statements
               SET stance = null
             WHERE stance = 'unsure'
          SQL
        end
      end
    end
  end
end
