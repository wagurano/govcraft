class SympathiesController < ApplicationController
  load_and_authorize_resource

  def index
    @sympathies = Sympathy.recent
  end

  def show
    @sympathy.increment!(:views_count)
  end

  def create
    @sympathy.user = current_user
    if @sympathy.save
      redirect_to @sympathy
    else
      render 'new'
    end
  end

  def update
    if @sympathy.update_attributes(sympathy_params)
      redirect_to @sympathy
    else
      errors_to_flash(@sympathy)
      render 'edit'
    end
  end

  def destroy
    unless @sympathy.destroy
      errors_to_flash(@sympathy)
    end
    redirect_to sympathies_path
  end

  private

  def sympathy_params
    params.require(:sympathy).permit(:title, :body, :cover_image, :social_image)
  end
end
