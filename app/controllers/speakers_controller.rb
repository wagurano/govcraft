class SpeakersController < ApplicationController
  load_and_authorize_resource

  def show
    if params[:tag].present?
      @agendas = Agenda.tagged_with(params[:tag])
      render 'show_by_tag'
    else
      @agendas = Agenda.all
    end
  end
end
