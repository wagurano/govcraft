class RemovePrblemAndSolutionAndOutlineFromAgendas < ActiveRecord::Migration[5.0]
  def change
    remove_column :agendas, :problem
    remove_column :agendas, :solution
    remove_column :agendas, :outline
    add_column :agendas, :name, :string
  end
end
