class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :prepare_meta_tags, if: "request.get?"
  after_action :prepare_flash
  after_action :store_location

  before_action do
    if browser.device.mobile?
      request.variant = :mobile
    end
  end


  if Rails.env.production? or Rails.env.staging?
    def action_missing(name)
      render_404
    end

    rescue_from ActiveRecord::RecordNotFound, ActionController::UnknownFormat do |exception|
      render_404
    end
    rescue_from CanCan::AccessDenied do |exception|
      begin
        self.response_body = nil
        if user_signed_in?
          redirect_to root_url, :alert => exception.message
        else
          redirect_to new_user_session_url, alert: '먼저 로그인 해주세요.'
        end
      rescue AbstractController::DoubleRenderError => e
      end
    end
    rescue_from ActionController::InvalidCrossOriginRequest, ActionController::InvalidAuthenticityToken do |exception|
      begin
        self.response_body = nil
        redirect_to root_url, :alert => I18n.t('errors.messages.invalid_auth_token')
      rescue AbstractController::DoubleRenderError => e
      end
    end
  end

  def store_location
    return unless request.get?
    if params[:redirect_to].present?
      store_location_for(:user, params[:redirect_to])
    elsif (!request.fullpath.match("/users") && !request.xhr?)
      store_location_for(:user, request.fullpath)
    end
  end

  def render_404
    begin
      self.response_body = nil
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    rescue AbstractController::DoubleRenderError => e
    end
  end

  def errors_to_flash(model)
    flash[:error] = model.errors.full_messages.join('<br>').html_safe
  end

  def prepare_meta_tags(options={})
    set_meta_tags build_meta_options(options)
  end

  def build_meta_options(options)
    site_name = "우리가 주인이당! Would You Party?"
    title = view_context.strip_tags(options[:title]) || "직접 민주주의 프로젝트 정당 우주당"
    image = options[:image] || view_context.image_url('seo.png')
    url = options[:url] || root_url
    description = view_context.strip_tags(options[:description]) || "직접 민주주의 프로젝트 정당 우주당 '우리가 주인이당!'입니다"
    {
      title:       title,
      reverse:     true,
      image:       image,
      description: description,
      keywords:    "시민, 정치, 국회, 입법, 법안, 민주주의, 온라인정치, 정치참여, 우리가 주인이당, 정치개혁, Would You Party",
      canonical:   url,
      twitter: {
        site_name: site_name,
        site: '@parti_xyz',
        card: 'summary',
        title: title,
        description: description,
        image: image
      },
      og: {
        url: url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }
  end

  #bugfix redactor2-rails
  def redactor_current_user
    redactor2_current_user
  end

  private

  def prepare_flash
    obtrusive_flash = flash.select { |key, value| !unobtrusive_flash_keys.include?(key.to_sym) } if flash.any?
    obtrusive_flash = [] if obtrusive_flash.blank?
    prepare_unobtrusive_flash
    obtrusive_flash.each do |key, value|
      flash[key] = value
    end
  end

  def redirect_back_for_robot
    flash[:error] = '로봇이세요? 로봇 여부를 확인해 주세요'
    redirect_back(fallback_location: root_path)
  end

  def init_google_drive_credentials(options = {})
    Google::Auth::UserRefreshCredentials.new({
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      scope: [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/",
      ]}.merge(options))
  end
end
