class LikesController < ApplicationController
  include LikeHelper

  load_and_authorize_resource

  def create
    @likable = @like.likable
    if user_signed_in?
      @like.user = current_user
      errors_to_flash(@like) unless @like.save
    else
      if !anonymous_liked?(@like.likable)
        if @likable.increment!(:anonymous_likes_count)
          mark_anonymous_liked @likable
        else
          errors_to_flash(@like)
        end
      end
    end
  end

  private

  def like_params
    params.require(:like).permit(:likable_id, :likable_type)
  end
end
