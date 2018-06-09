class IssuesController < ApplicationController
  load_and_authorize_resource

  def index
    @issues = Issue.all


    @issues = @issues.where('title like ?', "%#{params[:q]}%") if params[:q]
    @issues = @issues.page(params[:page]).per(30) if params[:page]
  end

  def show
    if params[:theme_slug].present?
      redirect_to theme_agendas_path(theme_slug: params[:theme_slug], anchor: view_context.dom_id(@issue))
    end
    @form_petition = Petition.new
  end
end
