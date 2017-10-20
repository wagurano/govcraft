class ArchivesController < ApplicationController
  load_and_authorize_resource
  before_action :verify_organization
  before_action :reset_meta_tags, only: :show
  before_action :fetch_current_organization, only: [:show, :edit]

  def index
    @archives = Archive.order('id DESC')
  end

  def show

    @category = @archive.all_categories.find_by(slug: params[:category_slug])
    @documents = @archive.documents
    @documents = @documents.tagged_with(params[:tag]) if params[:tag].present?
    @documents = @documents.where(category_slug: params[:category_slug]) if params[:category_slug].present?
    @documents = @documents.page(params[:page])

    if params[:q].present?
      @documents = @documents.search_for params[:q]
    end

  end

  def recent_documents
    @documents = @archive.documents.reorder('').recent.limit(10)
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
      render 'edit_categories'
    end
  end

  def destroy
    @archive.destroy
    redirect_to archives_path
  end

  def google_drive
    begin
      @drive_session = current_user.google_drive_session
      if params[:file_id].present?
        @collection = @drive_session.try(:file_by_id, params[:file_id])
      else
        @collection = @drive_session.try(:root_collection)
      end
      if params[:parent_id].present?
        @parent_collection = @drive_session.try(:file_by_id, params[:parent_id])
      end
      @files = []
      @collection.try(:files) do |f|
        @files << f
      end
      @files.sort_by { |file| file.title }
    rescue Google::Apis::AuthorizationError => e
    end
  end

  private

  def fetch_current_organization
    unless @archive.blank? or @archive.organization.blank?
      @current_organization = @archive.organization
    end
  end

  def archive_params
    params.require(:archive).permit(:title, :body, :slug, :organization_id, :cover_image, :cover_image_cache,
      :remove_cover_image, :social_image, :social_image_cache, :remove_social_image,
      :google_drive_client_id, :google_drive_client_secret,
      categories_attributes: [ :id, :slug, :name, :desc, :_destroy, children_attributes: [ :archive_id, :id, :slug, :name, :desc, :_destroy ] ] )
  end

  def reset_meta_tags
    prepare_meta_tags({
      title: '[타임라인] ' + @archive.title,
      description: @archive.body.html_safe,
      url: request.original_url}
    )
  end

  def current_organization
    @archive.try(:organization) || fetch_organization_of_request(request)
  end
end
