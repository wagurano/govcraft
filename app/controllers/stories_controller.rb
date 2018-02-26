class StoriesController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show
  before_action :verify_organization


  def index
    @stories = Story.recent

    @project = Project.find_by(slug: params[:project_id]) if params[:project_id]
    @stories = @stories.where(project: @project) if @project.present?

    @current_organization = fetch_organization_from_request
    @stories = @stories.by_organization(@current_organization) if @current_organization.present?
  end

  def show
    @project = @story.project
    @story.increment!(:views_count)
  end

  def new
    #@project = Project.find(params[:project_id]) if params[:project_id]
    @project = Project.find(params[:story][:project_id]) if params[:story][:project_id]
    @current_organization = @project.organization if @project.present?
  end

  def create
    @story.user = current_user
    if @story.save
      redirect_to @story || @project
    else
      errors_to_flash @story
      send('new')
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
      errors_to_flash @story
      render 'edit'
    end
  end

  def destroy
    @story.destroy
    redirect_to project_path(@story.project)
  end

  private

  def story_params
    params.require(:story).permit(:title, :body, :project_id, :cover, :comment_enabled, :published_at)
  end

  def reset_meta_tags
    prepare_meta_tags({
      site_name: ("#{@story.project.title}" if @story.project.present?),
      title: "[최신소식] " + @story.title,
      description: @story.body.html_safe,
      image: (view_context.image_url(@story.fallback_social_image_url) if @story.fallback_social_image_url),
      url: request.original_url}
    )
  end

  def current_organization
    if @story.present? and @story.persisted?
      @story.project.try(:organization)
    else
      fetch_organization_from_request
    end
  end
end
