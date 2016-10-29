class PollsController < ApplicationController
  load_and_authorize_resource :campaign, parent: true
  load_and_authorize_resource through: :campaign, shallow: true
  before_action :reset_meta_tags, only: :show

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

  def reset_meta_tags
    prepare_meta_tags({
      title: "[투표] " + @poll.title,
      description: @poll.body.html_safe,
      url: request.original_url}
    )
  end
end
