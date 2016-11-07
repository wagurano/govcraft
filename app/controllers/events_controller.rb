class EventsController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @evnts = Event.all
  end

  def new
  end

  def create
    @event.user = current_user
    if @event.save
      redirect_to @event
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    @event.destroy
    redirect_to evnts_path
  end

  private

  def event_params
    params.require(:event).permit(:slug, :title, :body)
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: @event.title,
      description: @event.body.html_safe,
      url: request.original_url}
    )
  end
end