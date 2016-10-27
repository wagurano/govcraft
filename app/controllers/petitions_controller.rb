class PetitionsController < ApplicationController
  load_and_authorize_resource :campaign, parent: true
  load_and_authorize_resource through: :campaign, shallow: true

  def index
    @petitions = @campaign.petitions
  end

  def show
    @campaign = @petition.campaign
  end

  def new
  end

  def create
    @petition.campaign = @campaign
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
    redirect_to campaign_path(@petition.campaign)
  end

  private

  def petition_params
    params.require(:petition).permit(:title, :body, :comments_goal_count)
  end
end