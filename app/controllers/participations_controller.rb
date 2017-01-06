class ParticipationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @project = Project.find_by id: params[:project_id]
    @project.participations.build(user: current_user)
    @participation = @project.save
    redirect_back fallback_location: root_path
  end

  def cancel
    @project = Project.find_by id: params[:project_id]
    @participation = @project.participations.find_by(user: current_user)
    @participation.destroy
    redirect_back fallback_location: root_path
  end

end
