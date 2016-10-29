class DiscussionsController < ApplicationController
  load_and_authorize_resource :campaign, parent: true
  load_and_authorize_resource through: :campaign, shallow: true
  before_action :reset_meta_tags, only: :show

  def index
    @discussions = @campaign.discussions.order("id DESC")
  end

  def show
    @campaign = @discussion.campaign
    @discussion.increment!(:views_count)
  end

  def new
  end

  def create
    @discussion.campaign = @campaign
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
    params.require(:discussion).permit(:title, :body)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @discussion.title,
      description: @discussion.body.html_safe,
      url: request.original_url}
    )
  end
end
