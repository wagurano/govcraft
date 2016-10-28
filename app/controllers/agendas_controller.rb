class AgendasController < ApplicationController
  load_and_authorize_resource

  def index
    @agendas = Agenda.all
  end

  def create
    @agenda.user = current_user
    if @agenda.save
      redirect_to @agenda
    else
      render 'new'
    end
  end

  def update
    if @agenda.update(agenda_params)
      redirect_to @agenda
    else
      render 'edit'
    end
  end

  def destroy
    @agenda.destroy
    redirect_to agendas_path
  end

  private

  def agenda_params
    params.require(:agenda).permit(:problem, :solution, :memo)
  end
end