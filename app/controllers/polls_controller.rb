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

    prepare_meta_tags title: @poll.title,
      description: @poll.body.truncate(100),
      url: poll_url,
      image: social_card_poll_url(format: :png),
      twitter_card_type: 'summary_large_image'
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

  def social_card
    respond_to do |format|
      format.png do
        if params[:no_cached]
          png = IMGKit.new(render_to_string(layout: nil), width: 1200, height: 630, quality: 10).to_png
          send_data(png, :type => "image/png", :disposition => 'inline')
        else
          if !@poll.social_card.file.try(:exists?) or (params[:update] and current_user.try(:admin?))
            file = Tempfile.new(["social_card_#{@poll.id.to_s}", '.png'], 'tmp', :encoding => 'ascii-8bit')
            file.write IMGKit.new(render_to_string(layout: nil), width: 1200, height: 630, quality: 10).to_png
            file.flush
            @poll.social_card = file
            @poll.save!
            file.unlink
          end
          if @poll.social_card.file.respond_to?(:url)
            data = open @poll.social_card.url
            send_data data.read, filename: "social_card.png", :type => "image/png", disposition: 'inline', stream: 'true', buffer_size: '4096'
          else
            send_file(@poll.social_card.path, :type => "image/png", :disposition => 'inline')
          end
        end
      end
      format.html { render(layout: nil) }
    end
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
