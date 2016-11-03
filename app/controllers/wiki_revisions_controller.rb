class WikiRevisionsController < ApplicationController
  load_and_authorize_resource

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
end
