class Admin::SpeakersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @speakers = Speaker.all
  end

  def create
    if @speaker.save
      redirect_to admin_speakers_path
    else
      render 'new'
    end
  end

  def update
    if @speaker.update(speaker_params)
      redirect_to admin_speakers_path
    else
      render 'edit'
    end
  end

  def destroy
    @speaker.destroy
    redirect_to admin_speakers_path
  end

  private

  def speaker_params
    params.require(:speaker).permit(:image, :name, :organization, :category, :position_list, :email)
  end
end
