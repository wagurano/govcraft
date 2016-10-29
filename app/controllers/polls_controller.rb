class PollsController < ApplicationController
  load_and_authorize_resource :campaign, parent: true
  load_and_authorize_resource through: :campaign, shallow: true

  def index
    @polls = @campaign.polls
  end

  def show
    @campaign = @poll.campaign
    @poll.increment!(:views_count)
  end

  def new
  end

  def create
    @poll.campaign = @campaign
    @poll.user = current_user
    if @poll.save
      redirect_to @poll || @campaign
    else
      render 'new'
    end
  end

  def edit
    @campaign = @poll.campaign
  end

  def update
    if @poll.update(poll_params)
      redirect_to @poll
    else
      render 'edit'
    end
  end

  def destroy
    @poll.destroy
    redirect_to campaign_path(@poll.campaign)
  end

  private

  def poll_params
    params.require(:poll).permit(:title, :body)
  end
end
