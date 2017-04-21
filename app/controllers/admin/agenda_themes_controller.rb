class Admin::AgendaThemesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @agenda_themes = AgendaTheme.all
  end

  def create
    if @agenda_theme.save
      redirect_to admin_agenda_themes_path
    else
      render 'new'
    end
  end

  def update
    if @agenda_theme.update(agenda_theme_params)
      redirect_to admin_agenda_themes_path
    else
      render 'edit'
    end
  end

  def destroy
    @agenda_theme.destroy
    redirect_to admin_agenda_themes_path
  end

  def add_agenda
    @agenda = Agenda.find_by(id: params[:agenda_id])
    @agenda_theme.agendas << @agenda
    @agenda_theme.save
    redirect_to admin_agenda_themes_path
  end

  def remove_agenda
    @agenda = Agenda.find_by(id: params[:agenda_id])
    @agenda_theme.agendas.delete @agenda
    @agenda_theme.save
    redirect_to admin_agenda_themes_path
  end

  private

  def agenda_theme_params
    params.require(:agenda_theme).permit(:title, :body, :slug, :cover, :cover_cache, :remove_cover, :project_id)
  end
end
