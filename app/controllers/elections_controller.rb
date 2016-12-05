class ElectionsController < ApplicationController
  load_and_authorize_resource
  def new
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
  end

  def create
    @election.user = current_user
    if @election.save
      redirect_to @election || @campaign
    else
      render 'new'
    end
  end

  def show
    @campaign = @election.campaign
    @candidate = Candidate.new
  end

  private

  def election_params
    params.require(:election).permit(:title, :body, :image, :campaign_id,
      :registered_from, :registered_to, :voted_from, :voted_to)
  end
end
