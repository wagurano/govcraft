class AddAgendaToSentRequests < ActiveRecord::Migration[5.0]
  def up
    add_reference :sent_requests, :agenda

    ActiveRecord::Base.transaction do
      SentRequest.all.each do |sent_request|
        sent_request.update_columns(agenda_id: 4)
      end
    end
  end

  def down
    raise "unsupport!"
  end
end
