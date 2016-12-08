class SignsController < ApplicationController
  before_action :authenticate_user!, except: :create
  load_and_authorize_resource

  def index
    @petition = Petition.find params[:petition_id]
    @signs = @petition.signs.page params[:page]
  end

  def create
    @sign.user = current_user if user_signed_in?
    if @sign.save
      flash[:notice] = I18n.t('messages.signed')
    else
      errors_to_flash(@sign)
    end
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
    params.require(:sign).permit(:body, :petition_id, :signer_name, :signer_email)
  end
end
