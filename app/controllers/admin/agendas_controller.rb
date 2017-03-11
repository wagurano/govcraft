class Admin::AgendasController < Admin::BaseController
  load_and_authorize_resource

  def index
    @agendas = Agenda.all
  end

  def create
    @agenda.user = current_user
    if @agenda.save
      redirect_to admin_agendas_path
    else
      render 'new'
    end
  end

  def update
    if @agenda.update(agenda_params)
      redirect_to admin_agendas_path
    else
      render 'edit'
    end
  end

  def destroy
    @agenda.destroy
    redirect_to admin_agendas_path
  end

  private

  def agenda_params
    params.require(:agenda).permit(:name)
  end
end
