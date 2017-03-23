class AddRequestAmendmentExampleToAgendas < ActiveRecord::Migration[5.0]
  def change
    add_column :agendas, :request_amendment_example, :text
  end
end
