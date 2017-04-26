class SpeakersController < ApplicationController
  load_and_authorize_resource

  def show
    @agendas = Agenda.where(id: Issue.where(id: @speaker.opinions.select(:issue_id)).select(:agenda_id))
    if params[:agenda_id].present?
      @agenda = Agenda.find params[:agenda_id]
      render 'speakers/show_agenda'
    end
  end
end
