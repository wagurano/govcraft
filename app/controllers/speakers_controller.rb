class SpeakersController < ApplicationController
  load_and_authorize_resource

  def show
    @agenda = Agenda.find_by(id: params[:agenda_id])

    @agendas = Agenda.where(id: Issue.where(id: @speaker.opinions.select(:issue_id)).select(:agenda_id))
    @agendas = @agendas.where.not(id: @agenda)
  end
end
