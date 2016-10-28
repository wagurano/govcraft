class SignsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    @sign.user = current_user
    errors_to_flash(@sign) unless @sign.save
    redirect_back(fallback_location: @petition)
  end

  def update
    errors_to_flash(@sign) unless @sign.update_attributes(sign_params)
    redirect_to(@sign.petition)
  end

  def destroy
    errors_to_flash(@sign) unless @sign.destroy
    redirect_to(@sign.petition)
  end

  private

  def sign_params
    params.require(:sign).permit(:body, :petition_id)
  end
end
