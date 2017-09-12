class StoriesController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @stories = Story.recent
  end

  def show
    @project = @story.project
    @story.increment!(:views_count)
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def create
    @story.user = current_user
    if @story.save
      redirect_to @story || @project
    else
      render 'new'
    end
  end

  def edit
    @project = @story.project
  end

  def update
    if @story.update(story_params)
      redirect_to @story
    else
      render 'edit'
    end
  end

  def destroy
    @story.destroy
    redirect_to project_path(@story.project)
  end

  private

  def story_params
    params.require(:story).permit(:title, :body, :project_id, :cover, :comment_enabled)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: "[최신소식] " + @story.title,
      description: @story.body.html_safe,
      image: (view_context.image_url(@story.fallback_social_image_url) if @story.fallback_social_image_url),
      url: request.original_url}
    )
  end
end