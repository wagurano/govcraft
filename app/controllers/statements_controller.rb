class StatementsController < ApplicationController
  load_and_authorize_resource only: :create
  def create
    @statement.last_updated_user = current_user
    if @statement.save
      flash[:notice] = I18n.t('messages.saved')
    else
      errors_to_flash(@statement)
    end

    redirect_to polymorphic_path([:edit_statements, @statementable], agent_id: @statement.agent.id)
  end

  def update
    @statement = Statement.find_by(id: params[:id])
    render_404 and return if @statement.blank?
    render_404 and return if !@statement.valid_key?(params[:key]) and @statement.agent.access_token != params[:access_token] and !can?(:edit, @statement)

    @statement.assign_attributes(statement_params)
    @statement.last_updated_user = current_user
    if @statement.save
      flash[:notice] = I18n.t('messages.saved')
    else
      errors_to_flash(@statement)
    end
    redirect_to params[:after_save_url] || @statement.statementable
  end

  private

  def statement_params
    params.require(:statement).permit(:body, :stance)
  end
end
