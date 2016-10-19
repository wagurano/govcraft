class CampaignsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @campaigns = Campaign.all
  end

  def show
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
    params.require(:campaign).permit(:title, :body)
  end
end