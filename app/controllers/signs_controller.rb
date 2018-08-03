class SignsController < ApplicationController
  before_action :authenticate_user!, except: [:create, :index]
  load_and_authorize_resource except: [:mail_form, :mail]
  invisible_captcha only: [:create]

  def index
    @petition = Petition.find params[:petition_id]
    @signs = @petition.signs.page params[:page]
  end

  def create
    if user_signed_in? and @sign.petition.signed?(current_user)
      flash[:notice] = t('messages.already_signed')
      redirect_to(@sign.petition) and return
    end

    if @sign.petition.closed?
      flash[:notice] = t('messages.petitions.closed')
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

  def mail_form
    @petition = Petition.find_by(id: params[:petition_id])
    render_404 and return if @petition.blank?

    authorize! :mail_signs, @petition
    if @petition.signs.empty?
      flash[:error] = t('messages.signs.mail.empty_signer')
      redirect_back(fallback_location: @petition)
    end
  end

  def mail
    @petition = Petition.find_by(id: params[:petition_id])
    render_404 and return if @petition.blank?
    authorize! :mail_signs, @petition

    if params[:preview_email].blank? and params[:preview] == "true"
      flash[:error] = t('messages.signs.mail.blank_preview_email')
      redirect_back(fallback_location: @petition)
      return
    end

    SignsMailingJob.perform_async(@petition.id, params[:title], params[:body], (params[:preview_email] if params[:preview] == 'true'), current_user.id)
    if params[:preview] == 'true'
      flash[:success] = t('messages.signs.mail.preview_completed')
    else
      flash[:success] = t('messages.signs.mail.completed')
    end
    redirect_to @petition
  end

  private

  def sign_params
    params.require(:sign).permit(:body, :petition_id,
      :signer_name, :signer_email, :signer_address, :signer_real_name, :signer_phone,
      :extra_29_confirm_join)
  end
end
