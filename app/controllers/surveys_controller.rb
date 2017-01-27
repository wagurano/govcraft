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
      render 'edit'
    end
  end

  def destroy
    @survey.destroy
    redirect_to @survey.project ? project_path(@survey.project) : surveys_path
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :body, :project_id, :duration, :cover_image, options_attributes: [:id, :body])
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: "[투표] " + @survey.title,
      description: @survey.body.html_safe,
      url: request.original_url}
    )
  end
end
