class SpeechesController < ApplicationController
  load_and_authorize_resource

  def index
    @petition = Petition.find(params[:petition_id]) if params[:petition_id]
    @speeches = Speech.all.recent.page params[:page]
  end

  def new
    @petition = Petition.find(params[:petition_id]) if params[:petition_id]
  end

  def create
    @speech.user = current_user
    if @speech.save
      redirect_to @speech.petition
    else
      render 'new'
    end
  end

  private
  def speech_params
    params.require(:speech).permit(:title, :video_url, :petition_id)
  end
end
