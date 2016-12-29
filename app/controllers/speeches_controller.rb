class SpeechesController < ApplicationController
  load_and_authorize_resource

  def index
    @event = Event.find(params[:event_id]) if params[:event_id]
    @speeches = Speech.all.recent.page params[:page]
  end

  def new
    @event = Event.find(params[:event_id]) if params[:event_id]
  end

  def create
    @speech.user = current_user
    if @speech.save
      redirect_to @speech.event
    else
      render 'new'
    end
  end

  private
  def speech_params
    params.require(:speech).permit(:title, :video_url, :event_id)
  end
end
