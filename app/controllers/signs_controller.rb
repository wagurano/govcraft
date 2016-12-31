class SignsController < ApplicationController
  before_action :authenticate_user!, except: [:create, :index]
  load_and_authorize_resource

  def index
    @petition = Petition.find params[:petition_id]
    @signs = @petition.signs.page params[:page]
  end

  def create
    if !verify_recaptcha(model: @sign) and !user_signed_in?
      redirect_back_for_robot and return
    end

    if user_signed_in? and @sign.petition.signed?(current_user)
      flash[:notice] = t('messages.already_signed')
      redirect_to(@sign.petition) and return
    end

    @sign.user = current_user if user_signed_in?
    if @sign.save
      flash[:sign_notice] = view_context.fill_in(@sign.petition.thanks_mention, number: @sign.petition.signs_count) || I18n.t('messages.signed')
    else
      errors_to_flash(@sign)
    end
    redirect_back(fallback_location: @petition)
  end

  def update
    if @sign.update_attributes(sign_params)
      flash[:success] = t('messages.saved')
    else
      errors_to_flash(@sign)
    end
    redirect_to(@sign.petition)
  end

  def destroy
    errors_to_flash(@sign) unless @sign.destroy
    redirect_to(@sign.petition)
  end

  private

  def sign_params
    params.require(:sign).permit(:body, :petition_id, :signer_name, :signer_email, :extra_29_confirm_join)
  end
end
