class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @petitions = Petition.recent
  end

  def show
    @campaign = @petition.campaign
    @petition.increment!(:views_count)
    @signs = @petition.signs.page params[:page]

    if params[:mode] == 'widget'
      render layout: 'strip'
    end
  end

  def data
  end

  def new
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id].present?
  end

  def create
    @petition.user = current_user
    if @petition.save
      redirect_to @petition || @campaign
    else
      render 'new'
    end
  end

  def edit
    @campaign = @petition.campaign
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
    redirect_to @petition.campaign ? campaign_path(@petition.campaign) : petitions_path
  end

  private

  def petition_params
    params.require(:petition).permit(:title, :body, :campaign_id, :signs_goal_count, :cover_image)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: "[서명] " + @petition.title,
      description: @petition.body.html_safe,
      image: view_context.image_url(@petition.cover_image_url),
      url: request.original_url}
    )
  end
end
