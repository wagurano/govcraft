class PagesController < ApplicationController
  include OrganizationHelper

  before_action :subdomain_view_path, only: :home

  def home
    home_method = :"home_#{@current_organization.try(:slug)}"
    reset_meta_tags_for_home(@current_organization)
    if respond_to? home_method
      send home_method
    end

    @projects = Project.recent
    @timelines = Timeline.recent
    @memorials = Memorial.recent
    @articles = Article.hot.limit(10)
    @project_categories = ProjectCategory.where(organization: @current_organization) if @current_organization.present?

    @issues = Issue.limit(6)
  end

  def home_urimanna
    json = Rails.cache.read "urimanna_parti_highlight_posts"

    @pinned_posts = json.try(:[], "pinned") || []
    @recent_posts = json.try(:[], "recent") || []

    if json.nil?
      PartiHightlightPostsJob.perform_async
    end
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
    @current_organization ||= fetch_organization_from_request
    if @current_organization.blank?
      redirect_to "http://#{Rails.application.routes.default_url_options[:host]}"
      return
    end
    prepend_view_path "app/views/organizations/#{@current_organization.slug}"
  end

  def reset_meta_tags_for_home(organization)
    prepare_meta_tags({
      site_name: organization.try(:site_name).try(:html_safe),
      title: organization.try(:title).try(:html_safe),
      description: organization.try(:description).try(:html_safe),
      url: request.original_url}
    )
  end
end
