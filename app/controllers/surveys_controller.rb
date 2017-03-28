class SurveysController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @surveys = Survey.recent
  end

  def show
    @project = @survey.project
    @survey.increment!(:views_count)

    if params[:mode] == 'widget'
      render layout: 'strip'
    end

    prepare_meta_tags title: @survey.title,
      description: ApplicationController.helpers.strip_tags(@survey.body).strip.truncate(100),
      url: survey_url,
      image: social_card_survey_url(format: :png),
      twitter_card_type: 'summary_large_image'
  end

  def new
    @project = Project.find(params[:project_id]) if params[:project_id]
    2.times do
      @survey.options.build
    end
  end

  def create
    @survey.user = current_user
    if @survey.save
      redirect_to @survey || @project
    else
      errors_to_flash(@survey)
      render 'new'
    end
  end

  def edit
    @project = @survey.project
  end

  def update
    if @survey.update(survey_params)
      redirect_to @survey
    else
      errors_to_flash(@survey)
      render 'edit'
    end
  end

  def destroy
    @survey.destroy
    redirect_to @survey.project ? project_path(@survey.project) : surveys_path
  end

  def social_card
    respond_to do |format|
      format.png do
        if params[:no_cached]
          png = IMGKit.new(render_to_string(layout: nil), width: 1200, height: 630, quality: 10).to_png
          send_data(png, :type => "image/png", :disposition => 'inline')
        else
          if !@survey.social_card.file.try(:exists?) or (params[:update] and current_user.try(:has_role?, :admin))
            file = Tempfile.new(["social_card_#{@survey.id.to_s}", '.png'], 'tmp', :encoding => 'ascii-8bit')
            file.write IMGKit.new(render_to_string(layout: nil), width: 1200, height: 630, quality: 10).to_png
            file.flush
            @survey.social_card = file
            @survey.save!
            file.unlink
          end
          if @survey.social_card.file.respond_to?(:url)
            data = open @survey.social_card.url
            send_data data.read, filename: "social_card.png", :type => "image/png", disposition: 'inline', stream: 'true', buffer_size: '4096'
          else
            send_file(@survey.social_card.path, :type => "image/png", :disposition => 'inline')
          end
        end
      end
      format.html { render(layout: nil) }
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :body, :project_id, :duration, :cover_image, :multi_selectable, options_attributes: [:id, :body, :desc])
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: "[투표] " + @survey.title,
      description: @survey.body.html_safe,
      url: request.original_url}
    )
  end
end
