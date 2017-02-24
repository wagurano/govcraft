class ArchiveDocumentsController < ApplicationController
  load_and_authorize_resource

  def show
    @archive = @archive_document.archive
    @documents = params[:tag].present? ? @archive.documents.tagged_with(params[:tag]) : @archive.documents
    @documents = @documents.page(params[:page])
  end

  def new
    @archive = Archive.find(params[:archive_id])
    @archive_document = @archive.documents.build
  end

  def create
    @archive_document.user = current_user
    if @archive_document.save
      redirect_to archive_path(@archive_document.archive)
    else
      render 'new'
    end
  end

  def edit
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
      :content, :content_cache, :remove_content,
      :category_slug, :donor, :is_secret_donor
    )
  end
end
