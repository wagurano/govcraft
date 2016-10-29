class CampaignsController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @campaigns = Campaign.order('id DESC')
  end

  def show
    @campaign.increment!(:views_count)
  end

  def new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user
    if @campaign.save
      redirect_to @campaign
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign
    else
      render 'edit'
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :body, :image)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @campaign.title,
      description: @campaign.body.html_safe,
      image: @campaign.image.url,
      url: request.original_url}
    )
  end
end
