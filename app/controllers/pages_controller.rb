class PagesController < ApplicationController
  include OrganizationHelper

  before_action :subdomain_view_path, only: :home

  def home
    @projects = Project.recent
    @timelines = Timeline.recent
    @memorials = Memorial.recent
    @articles = Article.hot.limit(10)
  end

  def about
  end

  def polls
    @polls = Poll.recent
  end

  def petitions
    @petitions = Petition.recent
  end

  def discussions
    @discussions = Discussion.recent
  end

  private

  def subdomain_view_path
    return unless organizationable_request?(request)
    organization = fetch_organization_of_request(request)
    if organization.blank?
      redirect_to "http://#{Rails.application.routes.default_url_options[:host]}"
      return
    end
    prepend_view_path "app/views/organizations/#{organization.slug}"
  end
end
