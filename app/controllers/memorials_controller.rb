class MemorialsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @memorials = Memorial.all
  end

  def create
    @memorial.user = current_user
    if @memorial.save
      redirect_to @memorial
    else
      render 'new'
    end
  end

  def update
    if @memorial.update(petition_params)
      redirect_to @memorial
    else
      render 'edit'
    end
  end

  def destroy
    @memorial.destroy
    redirect_to memorials_path
  end

  private

  def memorial_params
    params.require(:memorial).permit(:title, :body)
  end
end