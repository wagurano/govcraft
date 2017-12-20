class OrganizersController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:project_id].present?
      @organizable = Project.find_by id: params[:project_id]
    else
      @organizable = fetch_organization_from_request
    end
    render_404 and return if @organizable.blank?
  end

  def create
    user_nickname = params[:user_nickname]
    user = User.find_by(nickname: user_nickname)
    redirect_back(fallback_location: root_path) and return if user.blank? or
      @organizer.organizable.blank? or
      @organizer.organizable.organizers.exists?(user: user)

    @organizer.user = user
    if !@organizer.save
      errors_to_flash(@organizer)
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @organizer.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def organizer_params
    params.require(:organizer).permit(:organizable_type, :organizable_id)
  end
end
