class WikiRevisionsController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource
  before_action :verify_organization

  def show
    @project = @wiki_revision.wiki.project
  end

  def revert
    @wiki = @wiki_revision.wiki
    @wiki.body = @wiki_revision.body
    @wiki.wiki_revisions.build(user: current_user, body: @wiki.body, note: "#{@wiki_revision.id} 버전으로 복원")
    if @wiki.save
      flash[:success] = I18n.t('messages.reverted')
      redirect_to @wiki
    else
      errors_to_flash(@wiki)
      redirect_back fallback_location: @wiki_revision
    end
  end

  private

  def current_organization
    if @wiki_revision.present? and @wiki_revision.persisted?
      @wiki_revision.wiki.try(:project).try(:organization)
    else
      fetch_organization_from_request
    end
  end
end
