class AdminsController < ApplicationController
  load_and_authorize_resource

  def index
    @project = Project.find_by id: params[:project_id]
    render_404 and return if @project.blank?
  end

  def create
    user_nickname = params[:user_nickname]
    user = User.find_by(nickname: user_nickname)
    redirect_back(fallback_location: root_path) and return if user.blank? or
      @admin.adminable.blank? or
      @admin.adminable.admins.exists?(user: user)

    @admin.user = user
    if !@admin.save
      errors_to_flash(@admin)
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @admin.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def admin_params
    params.require(:admin).permit(:adminable_type, :adminable_id)
  end
end
