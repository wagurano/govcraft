class SympathiesController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

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

  def reset_meta_tags
    prepare_meta_tags({
      title: "[추모] " + @sympathy.title.html_safe,
      description: @sympathy.body.html_safe,
      url: request.original_url,
      image: (view_context.image_url(@sympathy.social_image_url) if @sympathy.social_image_url),
    }
    )
  end
end
