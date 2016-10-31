class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    redirect_to root_path if params[:reportable_type].blank?

    @reportable = params[:reportable_type].safe_constantize.try(:find, params[:reportable_id])
    redirect_to root_path if @reportable.blank?

    @report = Report.new(reportable: @reportable, user: current_user)
    if @report.save
      flash[:success] = t('messages.reported')
    else
      errors_to_flash(@report)
    end
    redirect_back fallback_location: @reportable
  end
end
