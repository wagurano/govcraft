class Admin::IssuesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @issues = Issue.all
    @issues = Agenda.find_by(id: params[:agenda_id]).issues if params[:agenda_id].present?
    @issues = @issues.search_for(params[:q]) if params[:q].present?
  end

  def create
    if @issue.save
      redirect_to admin_issues_path
    else
      errors_to_flash(@issue)
      render 'new'
    end
  end

  def update
    if @issue.update(issue_params)
      redirect_to admin_issues_path
    else
      render 'edit'
    end
  end

  def destroy
    @issue.destroy
    redirect_to admin_issues_path
  end

  def edit_petitions
  end

  def search_petitions
    @petitions = Petition.search_for(params[:q])
    @petitions = @petitions.page(params[:page]).per(30) if params[:page]
  end

  def add_petition
    @petition = Petition.find_by(id: params[:petition_id])
    render_404 and return if @petition.blank?
    @petition.update_attributes(issue: @issue)

    redirect_to [:edit_petitions, :admin, @issue]
  end

  def remove_petition
    @petition = Petition.find_by(id: params[:petition_id])
    render_404 and return if @petition.blank?
    @petition.update_attributes(issue: nil)

    redirect_to [:edit_petitions, :admin, @issue]
  end

  private

  def issue_params
    params.require(:issue).permit(:agenda_theme_id, :title, :body, :tag_list, :has_stance, agenda_ids: [])
  end
end
