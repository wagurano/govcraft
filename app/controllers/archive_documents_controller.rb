class ArchiveDocumentsController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource
  before_action :verify_organization

  def index
  end

  def show
    @archive = @archive_document.archive
    @documents = params[:tag].present? ? @archive.documents.tagged_with(params[:tag]) : @archive.documents
    @documents = @documents.page(params[:page])
    render_show
  end

  def new
    @archive ||= Archive.find(params[:archive_id])
    @archive_document.archive = @archive
    @current_organization = @archive.organization
    render_new
  end

  def create
    @archive_document.user = current_user
    if @archive_document.save
      redirect_to archive_path(@archive_document.archive)
    else
      errors_to_flash(@archive_document)
      @archive = @archive_document.archive
      render_new
    end
  end

  def edit
    @archive = @archive_document.archive
    render_edit
  end

  def update
    if @archive_document.update(archive_document_params)
      redirect_to @archive_document
    else
      render 'edit'
    end
  end

  def destroy
    @archive_document.destroy
    redirect_to archive_path(@archive_document.archive)
  end

  def download
    if @archive_document.content.file.respond_to?(:url)
      # s3
      data = open @archive_document.content.url
      send_data data.read, filename: encoded_file_name(@archive_document), disposition: 'attachment', stream: 'true', buffer_size: '4096'
    else
      # local storage
      send_file @archive_document.content.path, filename: encoded_file_name(@archive_document), disposition: 'attachment'
    end
  end

  private

  def render_new
    render "archive_documents/#{@archive.slug}/new"
  end

  def render_show
    render "archive_documents/#{@archive.slug}/show"
  end

  def render_edit
    render "archive_documents/#{@archive.slug}/edit"
  end

  def encoded_file_name archive_document
    filename = archive_document.valid_name
    if browser.ie?
      filename = URI::encode(filename)
    elsif ENV['FILENAME_ENCODING'].present?
      filename = filename.encode('UTF-8', ENV['FILENAME_ENCODING'], invalid: :replace, undef: :replace, replace: '?')
    end
    filename
  end

  def archive_document_params
    params.require(:archive_document).permit(
      :archive_id,
      :title, :body, :tag_list,
      :content_creator, :content_created_date, :content_created_time,
      :content_source, :content_recipients,
      :content, :media_type, :content_cache, :remove_content,
      :category_slug, :donor, :is_secret_donor,
      additional_attributes: [:id, :sub_region, :address, :zipcode, :homepage, :tel, :fax, :leader, :leader_tel, :email, :business_area, :open_year, :members_count, :workers_count, :finance]
    )
  end

  def current_organization
    if @archive_document.present? and @archive_document.persisted?
      @archive_document.archive.try(:organization)
    else
      fetch_organization_from_request
    end
  end
end
