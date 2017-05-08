class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @petitions = Petition.recent
  end

  def show
    @project = @petition.project
    @petition.increment!(:views_count)
    @signs = @petition.signs.recent.where.not(body: [nil, ''])
    @signs = params[:mode] == 'widget' ? @signs.limit(10) : @signs.page(params[:page])

    if params[:mode] == 'widget'
      render '_widget', layout: 'strip'
    end
  end

  def data
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id].present?
  end

  def create
    @petition.user = current_user
    if @petition.save
      redirect_to @petition || @project
    else
      render 'new'
    end
  end

  def edit
    @project = @petition.project
  end

  def update
    if @petition.update(petition_params)
      redirect_to @petition
    else
      render 'edit'
    end
  end

  def destroy
    @petition.destroy
    redirect_to @petition.project ? project_path(@petition.project) : petitions_path
  end

  private

  def petition_params
    params.require(:petition).permit(:title, :body, :project_id, :signs_goal_count, :cover_image, :thanks_mention, :comment_enabled, :sign_title, :social_image)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: "[서명] " + @petition.title,
      description: @petition.body.html_safe,
      image: view_context.image_url(@petition.social_image_url),
      url: request.original_url}
    )
  end
end
