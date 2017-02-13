class ArchivesController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show

  def index
    @archives = Archive.order('id DESC')
  end

  def show
    @documents = @archive.documents
    @documents = @documents.tagged_with(params[:tag]) if params[:tag].present?
    @documents = @documents.where(category_slug: params[:category_slug]) if params[:category_slug].present?
  end

  def download
    @archive = Archive.find(params[:id])
    respond_to do |format|
      format.xlsx
    end
  end

  def create
    @archive.user = current_user
    if @archive.save
      redirect_to @archive
    else
      errors_to_flash(@archive)
      render 'new'
    end
  end

  def edit
  end

  def update
    if @archive.update(archive_params)
      redirect_to @archive
    else
      errors_to_flash(@archive)
      render 'edit'
    end
  end

  def update_categories
    if @archive.update(archive_params)
      redirect_to @archive
    else
      errors_to_flash(@archive)
      render 'categories'
    end
  end

  def destroy
    @archive.destroy
    redirect_to archives_path
  end

  private

  def archive_params
    params.require(:archive).permit(:title, :body, :cover_image, :cover_image_cache,
      :remove_cover_image, :social_image, :social_image_cache, :remove_social_image,
      categories_attributes: [ :id, :slug, :name, :_destroy, children_attributes: [ :archive_id, :id, :slug, :name, :_destroy ] ] )
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: '[타임라인] ' + @archive.title,
      description: @archive.body.html_safe,
      url: request.original_url}
    )
  end
end
