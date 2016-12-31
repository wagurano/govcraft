class Admin::CommentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @comments = Comment.all.recent.page params[:page]
  end

  def destroy
    @comment.destroy
    redirect_to :back
  end
end
