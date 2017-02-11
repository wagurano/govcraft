class TimelinesController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @timelines = Timeline.order('id DESC')
  end

  def show
    @documents = params[:tag].present? ? @timeline.documents.tagged_with(params[:tag]) : @timeline.documents

    if %w(timeline list).include? params[:mode]
      render layout: false
    end
  end

  def download
    @timeline = Timeline.find(params[:id])
    respond_to do |format|
      format.xlsx
    end
  end

  def create
    @timeline.user = current_user
    if @timeline.save
      redirect_to @timeline
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @timeline.update(timeline_params)
      redirect_to @timeline
    else
      render 'edit'
    end
  end

  def destroy
    @timeline.destroy
    redirect_to timelines_path
  end

  private

  def timeline_params
    params.require(:timeline).permit(:title, :body, :image, :banner_image, :banner_url, :timeline_initial_zoom)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: '[타임라인] ' + @timeline.title,
      description: @timeline.body.html_safe,
      url: request.original_url}
    )
  end
end
