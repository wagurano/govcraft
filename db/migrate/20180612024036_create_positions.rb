class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.string :name
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        transaction do
          Agent.all.tags_on(:positions).each do |tag|
            Position.create!(name: tag.name)
          end
        end
      end
    end
  end
end
