class ApplicationController < ActionController::Base
  include OrganizationHelper

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
    current_organization = fetch_organization_from_request
    site_name = options[:site_name] || current_organization.try(:title) || "가브크래프트"
    title = view_context.strip_tags(options[:title]) || current_organization.try(:title) || "Democracy, everyday - 가브크래프트"
    image = options[:image] || (current_organization.try(:seo_image_path) and view_context.image_url(current_organization.try(:seo_image_path))) || view_context.image_url('seo.png')
    url = options[:url] || root_url
    description = view_context.strip_tags(options[:description]) || "게임하듯 정치하는 시민들의 놀이터 '가브크래프트'입니다"
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

  def after_sign_in_path_for(resource)
    omniauth_params = request.env['omniauth.params'] || session["omniauth.params_data"] || {}
    organization = Organization.find_by_slug(omniauth_params['organization_slug'])
    organization ||= fetch_organization_from_request

    result = stored_location_for(resource) || '/'
    if result.starts_with?('http')
      result_url = URI.parse(result)
      result = result_url.path
      result += "?" + result_url.query if result_url.query.present?
    end
    result = URI.join(root_url(subdomain: organization.subdomain), result).to_s if organization.present?
    result
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

  def verify_organization
    return unless request.format.html?

    @current_organization = send(:current_organization)
    valid_subdomain = @current_organization.try(:subdomain) || view_context.root_subdomain

    redirect_to subdomain: valid_subdomain and return unless fetch_organization_from_request == @current_organization
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end
end
