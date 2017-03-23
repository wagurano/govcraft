class AddRequestOpinionExampleToAgendas < ActiveRecord::Migration[5.0]
  def change
    add_column :agendas, :request_opinion_example, :text
  end
end
