class PollsController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show
  before_action :fetch_current_organization, only: [:show, :edit]

  def index
    @polls = Poll.recent
  end

  def show
    @project = @poll.project
    @poll.increment!(:views_count)

    if params[:mode] == 'widget'
      render layout: 'strip'
    end
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def create
    @poll.user = current_user
    if @poll.save
      redirect_to @poll || @project
    else
      render 'new'
    end
  end

  def edit
    @project = @poll.project
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
    redirect_to @poll.project ? project_path(@poll.project) : polls_path
  end

  def social_card
    respond_to do |format|
      format.png do
        if params[:no_cached]
          png = IMGKit.new(render_to_string(layout: nil), width: 1200, height: 630, quality: 10).to_png
          send_data(png, :type => "image/png", :disposition => 'inline')
        else
          if !@poll.social_card.file.try(:exists?) or (params[:update] and current_user.try(:has_role?, :admin))
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

  def fetch_current_organization
    unless @poll.project.blank? or @poll.project.organization.blank?
      @current_organization = @poll.project.organization
    end
  end

  def poll_params
    params.require(:poll).permit(:title, :body, :project_id, :cover_image)
  end

  def reset_meta_tags
    prepare_meta_tags title: @poll.title,
      description: ApplicationController.helpers.strip_tags(@poll.body).strip.truncate(100),
      url: poll_url,
      image: (if @poll.fallback_social_image_url.present?
        view_context.image_url(@poll.fallback_social_image_url)
      else
        social_card_poll_url(format: :png)
      end),
      twitter_card_type: 'summary_large_image'
  end
end
