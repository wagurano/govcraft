class ArchiveDocumentsController < ApplicationController
  load_and_authorize_resource

  def show
    @archive = @archive_document.archive
    @documents = params[:tag].present? ? @archive.documents.tagged_with(params[:tag]) : @archive.documents
  end

  def new
    @archive = Archive.find(params[:archive_id])
    @archive_document = @archive.documents.build
  end

  def create
    @archive_document.user = current_user
    if @archive_document.save
      redirect_to archive_path(@archive_document.archive, tab: :list)
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

  private

  def archive_document_params
    params.require(:archive_document).permit(
      :archive_id, :date, :time, :image, :source_url,
      :title, :body, :tag_list, :media_url, :media_credit
    )
  end
end
