class ProjectsController < ApplicationController
  load_and_authorize_resource find_by: :slug
  before_action :reset_meta_tags, only: [:show, :events]

  def index
    @projects = Project.order('id DESC')
  end

  def show
    @project.increment!(:views_count)
  end

  def events
    @project.increment!(:views_count)
  end

  def new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to @project
    else
      errors_to_flash(@project)
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(
      :title, :subtitle, :body,
      :image, :remove_image,
      :social_image, :remove_social_image,
      :slug,
      :discussion_enabled, :poll_enabled, :petition_enabled, :wiki_enabled,
      :discussion_title, :poll_title, :petition_title, :wiki_title,
      :discussion_sequence, :poll_sequence, :petition_sequence, :wiki_sequence, :event_sequence
    )
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @project.title,
      description: @project.body.html_safe,
      image: @project.image.url,
      url: request.original_url}
    )
  end
end
