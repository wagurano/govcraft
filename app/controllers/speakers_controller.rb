class SpeakersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    @agendas = Agenda.where(id: Issue.where(id: @speaker.opinions.select(:issue_id)).select(:agenda_id).distinct)
    if params[:agenda_id].present?
      @agenda = Agenda.find params[:agenda_id]
      respond_to do |format|
        format.js { render 'speakers/show_agenda' }
        format.html
      end
    end
  end
end
