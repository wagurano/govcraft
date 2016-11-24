class WikisController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @wikis = Wiki.recent
  end

  def show
    @campaign = @wiki.campaign
    @wiki.increment!(:views_count)
  end

  def new
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
  end

  def create
    @wiki.user = current_user
    @wiki.wiki_revisions.build(user: current_user, body: @wiki.body, note: @wiki.revision_note)
    if @wiki.save
      redirect_to @wiki || @campaign
    else
      render 'new'
    end
  end

  def edit
    @campaign = @wiki.campaign
  end

  def update
    @wiki.assign_attributes(wiki_params)
    @wiki.wiki_revisions.build(user: current_user, body: @wiki.body, note: @wiki.revision_note)
    if @wiki.save
      redirect_to @wiki
    else
      render 'edit'
    end
  end

  def destroy
    @wiki.destroy
    redirect_to campaign_path(@wiki.campaign)
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :campaign_id, :revision_note)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: "[위키] " + @wiki.title,
      description: @wiki.body.html_safe,
      url: request.original_url}
    )
  end
end
