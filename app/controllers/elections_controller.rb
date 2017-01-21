class ElectionsController < ApplicationController
  load_and_authorize_resource
  def new
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def create
    @election.user = current_user
    if @election.save
      redirect_to @election || @project
    else
      render 'new'
    end
  end

  def show
    @project = @election.project
    @candidate = Candidate.new
  end

  private

  def election_params
    params.require(:election).permit(:title, :body, :image, :project_id,
      :registered_from, :registered_to, :voted_from, :voted_to)
  end
end
