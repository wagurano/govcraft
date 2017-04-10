class IssuesController < ApplicationController
  load_and_authorize_resource

  def show
    @agenda = @issue.agenda
    if params[:theme_tag].present?
      redirect_to theme_agendas_path(theme_tag: params[:theme_tag], anchor: view_context.dom_id(@issue))
    end
  end
end
