class DiscussionsController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @discussions = Discussion.recent
  end

  def show
    @campaign = @discussion.campaign
    @discussion.increment!(:views_count)
  end

  def new
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
  end

  def create
    @discussion.user = current_user
    if @discussion.save
      redirect_to @discussion || @campaign
    else
      render 'new'
    end
  end

  def edit
    @campaign = @discussion.campaign
  end

  def update
    if @discussion.update(discussion_params)
      redirect_to @discussion
    else
      render 'edit'
    end
  end

  def destroy
    @discussion.destroy
    redirect_to campaign_path(@discussion.campaign)
  end

  private

  def discussion_params
    params.require(:discussion).permit(:title, :body, :campaign_id)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @discussion.title,
      description: @discussion.body.html_safe,
      url: request.original_url}
    )
  end
end
