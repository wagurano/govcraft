class AddOutlineToAgendas < ActiveRecord::Migration[5.0]
  def change
    add_column :agendas, :outline, :string
  end
end
