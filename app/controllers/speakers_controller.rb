class SpeakersController < ApplicationController
  load_and_authorize_resource

  def show
    if params[:agenda_id].present?
      @agenda = Agenda.find(params[:agenda_id])
    elsif params[:tag].present?
      @agendas = Agenda.tagged_with(params[:tag])
      render 'show_by_tag'
    end
  end
end
