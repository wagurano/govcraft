class DiscussionsController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @discussions = Discussion.recent
  end

  def show
    @project = @discussion.project
    @discussion.increment!(:views_count)
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def create
    @discussion.user = current_user
    if @discussion.save
      redirect_to @discussion || @project
    else
      render 'new'
    end
  end

  def edit
    @project = @discussion.project
  end

  def update
    if @discussion.update(discussion_params)
      redirect_to @discussion
    else
      render 'edit'
    end
  end

  def destroy
    @discussion.destroy
    redirect_to @discussion.project || discussions_path
  end

  private

  def discussion_params
    params.require(:discussion).permit(:title, :body, :project_id)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @discussion.title,
      description: @discussion.body.html_safe,
      url: request.original_url}
    )
  end
end
