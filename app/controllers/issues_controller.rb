class IssuesController < ApplicationController
  load_and_authorize_resource

  def show
    @agenda = @issue.agenda
    if params[:theme_slug].present?
      redirect_to theme_agendas_path(theme_slug: params[:theme_slug], anchor: view_context.dom_id(@issue))
    end
  end
end
