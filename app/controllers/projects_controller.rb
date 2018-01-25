class ProjectsController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource find_by: :slug
  before_action :reset_meta_tags, only: [:show, :events]
  before_action :verify_organization

  def index
    @projects = Project.order('id DESC')
    @current_organization = fetch_organization_from_request
    @projects = @projects.where(organization: @current_organization) if @current_organization.present?
    if params[:c].present?
      @projects = @projects.where(project_category: params[:c])
    end
  end

  def show
    if @project.townhall_enabled and @project.townhall_id.present?
      json = RestClient.get "#{ENV["TOWNHALL_API_BASE"]}/meetings/#{@project.townhall_id}.json"
      parsed_json = JSON.parse(json.body)
      @battles = parsed_json.try(:[], "battles") || []
    end
    @project.increment!(:views_count)
  end

  def new
    @current_organization = current_organization
  end

  def create
    @project = Project.new(project_params)
    if current_user.is_admin?
      @project.user = fetch_user_from_params || current_user
    else
      @project.user = current_user
    end
    @project.organization = fetch_organization_from_request
    if @project.save
      @project.organizers.create(user: current_user)
      redirect_to @project
    else
      errors_to_flash(@project)
      render 'new'
    end
  end

  def edit
    @project.user_nickname = @project.user.nickname
  end

  def update
    @project.assign_attributes(project_params)
    if current_user.is_admin?
      @project.user = fetch_user_from_params || @project.user
      @project.organization_id = params[:project][:organization_id]
    end

    if @project.save
      redirect_to @project
    else
      errors_to_flash(@project)
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private

  def fetch_user_from_params
    User.find_by nickname: params[:project][:user_nickname] if params[:project][:user_nickname].present?
  end

  def project_params
    params.require(:project).permit(
      :title, :subtitle, :user_nickname, :body,
      :image, :remove_image,
      :social_image, :remove_social_image,
      :slug, :project_category_id,
      :story_enabled, :discussion_enabled, :poll_enabled, :petition_enabled, :wiki_enabled,
      :story_title, :discussion_title, :poll_title, :petition_title, :wiki_title,
      :story_sequence, :discussion_sequence, :poll_sequence, :petition_sequence, :wiki_sequence, :event_enabled, :event_sequence,
      :townhall_enabled, :townhall_title, :townhall_sequence, :townhall_id,
      :event_title
    )
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @project.title,
      description: @project.body.html_safe,
      image: view_context.image_url(@project.fallback_social_image_url),
      url: request.original_url}
    )
  end

  def current_organization
    if @project.present? and @project.persisted?
      @project.organization
    else
      fetch_organization_from_request
    end
  end
end
