class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :create
  load_and_authorize_resource

  def create
    @comment.user = current_user if user_signed_in?
    if @comment.commentable.respond_to? :voted_by? and @comment.commentable.voted_by? current_user
      @comment.choice = @comment.commentable.fetch_vote_of(current_user).choice
    end
    if @comment.save
      flash[:notice] = I18n.t('messages.commented')
    else
      errors_to_flash(@comment)
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @comment.destroy
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :commenter_name, :commenter_email)
  end
end
