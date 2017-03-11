class Admin::IssuesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @issues = Issue.all
  end

  def create
    if @issue.save
      redirect_to admin_issues_path
    else
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

  private

  def issue_params
    params.require(:issue).permit(:agenda_id, :title)
  end
end
