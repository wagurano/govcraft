class LikesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    @like.user = current_user
    errors_to_flash(@like) unless @like.save
    redirect_back(fallback_location: root_path)
  end

  private

  def like_params
    params.require(:like).permit(:likable_id, :likable_type)
  end
end
