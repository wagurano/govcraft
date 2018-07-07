class EnumerizeCategoryOfAgents < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE agents
               SET category = '개인'
          SQL
        end
      end
    end
  end
end
