class Admin::AgendaDocumentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @agenda_documents = AgendaDocument.all.recent
  end

  def create
    if @agenda_document.save
      redirect_to admin_agenda_documents_path
    else
      render 'new'
    end
  end

  def update
    if @agenda_document.update(agenda_document_params)
      redirect_to admin_agenda_documents_path
    else
      render 'edit'
    end
  end

  def destroy
    @agenda_document.destroy
    redirect_to admin_agenda_documents_path
  end

  def new
    @agenda_document.agenda_id = params[:agenda_id] if params[:agenda_id].present?
    @agenda_document.agent_id = params[:agent_id] if params[:agent_id].present?
  end

  private

  def agenda_document_params
    params.require(:agenda_document).permit(:agenda_id, :agent_id, :attachment, :attachment_cache, :desc)
  end
end
