class MemorialsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :campaign, parent: true
  load_and_authorize_resource through: :campaign, shallow: true

  def show
    @campaign = @memorial.campaign
  end

  def new
  end

  def create
    @memorial.campaign = @campaign
    @memorial.user = current_user
    if @memorial.save
      redirect_to @memorial || @campaign
    else
      render 'new'
    end
  end

  def edit
    @campaign = @memorial.campaign
  end

  def update
    if @memorial.update(petition_params)
      redirect_to @memorial
    else
      render 'edit'
    end
  end

  def destroy
    @memorial.destroy
    redirect_to campaign_path(@memorial.campaign)
  end

  private

  def memorial_params
    params.require(:memorial).permit(:title, :body)
  end
end