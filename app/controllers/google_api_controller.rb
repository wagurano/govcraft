class GoogleApiController < ApplicationController
  before_action :authenticate_user!

  def auth_callback
    credentials = init_google_drive_credentials(
      redirect_uri: auth_callback_google_api_url)
    credentials.code = params[:code]
    credentials.fetch_access_token!

    current_user.update_attributes(
      google_access_token: credentials.access_token,
      google_refresh_token: credentials.refresh_token)

    redirect_to params[:state] || root_path
  end

  def auth
    credentials = init_google_drive_credentials(
      state: params[:redirect_uri],
      redirect_uri: auth_callback_google_api_url)
    redirect_to credentials.authorization_uri.to_s
  end
end
