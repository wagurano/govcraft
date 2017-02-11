class TimelineDocumentsController < ApplicationController
  load_and_authorize_resource

  def show
    @timeline = @timeline_document.timeline
    @documents = params[:tag].present? ? @timeline.documents.tagged_with(params[:tag]) : @timeline.documents
  end

  def new
    @timeline = Timeline.find(params[:timeline_id])
    @timeline_document = @timeline.documents.build
  end

  def create
    @timeline_document.user = current_user
    if @timeline_document.save
      redirect_to timeline_path(@timeline_document.timeline, tab: :list)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @timeline_document.update(timeline_document_params)
      redirect_to @timeline_document
    else
      render 'edit'
    end
  end

  def destroy
    @timeline_document.destroy
    redirect_to timeline_path(@timeline_document.timeline)
  end

  private

  def timeline_document_params
    params.require(:timeline_document).permit(
      :timeline_id, :date, :time, :image, :source_url,
      :title, :body, :tag_list, :media_url, :media_credit
    )
  end
end
