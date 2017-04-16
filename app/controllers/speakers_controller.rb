class SpeakersController < ApplicationController
  load_and_authorize_resource

  def show
    @agendas = Agenda.where(id: Issue.where(id: @speaker.opinions.select(:issue_id)).select(:agenda_id))
  end

  def agenda
    @agenda = Agenda.find_by(id: params[:agenda_id])
  end
end
