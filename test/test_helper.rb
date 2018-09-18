ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require "minitest/rails/capybara"

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  fixtures :all
  # SeedFu.seed

  # Returns true if a test user is logged in.
  def signed_in?
    !session[:user_id].nil?
  end

  # Logs in a test user.
  def sign_in(user, options = {})
    raise "Not found user" if user.nil? or User.find_by(id: user.id).nil?
    remember_me = options[:remember_me] || '1'
    if integration_test?
      OmniAuth.config.add_mock(user.provider, {uid: user.uid, info: {uid: user.uid}})

      @headers ||= {}
      @headers["omniauth.auth"] = {provider: user.provider, uid: user.uid}
      post send("user_#{user.provider}_omniauth_callback_path"), params: {code: 'test'}, headers: @headers
      follow_redirect!
    else
      session[:user_id] = user.id
    end
  end

  private

  # Returns true inside an integration test.
  def integration_test?
    defined?(post_via_redirect)
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
