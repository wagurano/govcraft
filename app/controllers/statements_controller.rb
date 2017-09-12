class StatementsController < ApplicationController
  def update
    @statement = Statement.find_by(id: params[:id])
    render_404 and return unless @statement.valid_key?(params[:key])
    render_404 and return if @statement.blank?

    if @statement.update_attributes(statement_params)
      flash[:notice] = I18n.t('messages.saved')
    else
      errors_to_flash(@statement)
    end
    redirect_to @statement.petition
  end

  private

  def statement_params
    params.require(:statement).permit(:body, :stance)
  end
end
