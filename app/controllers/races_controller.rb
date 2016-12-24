class RacesController < ApplicationController
  load_and_authorize_resource

  def create
    @race.user = current_user
    if @race.save
      redirect_to people_path
    else
      errors_to_flash(@race)
      render 'new'
    end
  end

  def update
    if @race.update_attributes(race_params)
      redirect_to @race
    else
      errors_to_flash(@race)
      render 'edit'
    end
  end

  def destroy
    unless @race.destroy
      errors_to_flash(@race)
    end
    redirect_to people_path
  end

  private

  def race_params
    params.require(:race).permit(:title, :body)
  end
end
