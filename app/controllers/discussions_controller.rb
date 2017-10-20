class DiscussionsController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show
  before_action :verify_organization


  def index
    @discussions = Discussion.recent.page(params[:page])

    @project = Project.find_by(slug: params[:project_id]) if params[:project_id]
    @discussions = @discussions.where(project: @project) if @project.present?
    @discussions = @discussions.where(discussion_category_id: params[:discussion_category_id]) if params[:discussion_category_id]

    @current_organization = fetch_organization_of_request(request)
    @discussions = @discussions.by_organization(@current_organization) if @current_organization.present?
  end

  def show
    @project = @discussion.project
    @discussion.increment!(:views_count)
    @force_gnb_and_footer = true if @discussion.project.blank?
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id]
    @discussion.discussion_category_id = params[:discussion_category_id] if params[:discussion_category_id]
    @current_organization = @project.organization if @project.present?
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
    @discussion.assign_attributes(discussion_params)

    if @discussion.save
      redirect_to @discussion and return
    end

    render 'edit'
  end

  def destroy
    @discussion.destroy
    redirect_to @discussion.project || discussions_path
  end

  private

  def discussion_params
    params.require(:discussion).permit(:title, :body, :project_id, :discussion_category_id)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @discussion.title,
      description: @discussion.body.html_safe,
      image: (view_context.image_url(@discussion.fallback_social_image_url) if @discussion.fallback_social_image_url),
      url: request.original_url}
    )
  end

  def current_organization
    @discussion.try(:project).try(:organization) || fetch_organization_of_request(request)
  end

end
