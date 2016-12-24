class PlayersController < ApplicationController
  load_and_authorize_resource

  def new
    @player.race_id = params[:race_id]
  end

  def create
    @player.user = current_user
    if @player.save
      redirect_to @player.race
    else
      errors_to_flash(@player)
      render 'new'
    end
  end

  def destroy
    unless @player.destroy
      errors_to_flash(@player)
    end
    redirect_to @player.race
  end

  private

  def player_params
    params.require(:player).permit(:race_id, :person_id)
  end
end
