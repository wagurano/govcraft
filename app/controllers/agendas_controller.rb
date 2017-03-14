class AgendasController < ApplicationController
  load_and_authorize_resource

  def index
    @agendas = Agenda.order('id DESC')
  end

  def show
  end
end
