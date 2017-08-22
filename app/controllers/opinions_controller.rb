class OpinionsController < ApplicationController
  load_and_authorize_resource
  protect_from_forgery except: :vote_widget
  before_action :reset_meta_tags, only: :show

  def show
  end

  def vote_widget
    @votable = @opinion
    render layout: 'strip_without_footer'
  end

  private

  def reset_meta_tags
    description = nil
    if @opinion.quote.present?
      description = @opinion.quote
    elsif @opinion.stance.present?
      description = @opinion.stance_long_text_by_theme
    end

    full_description = "[#{@opinion.issue.agenda_theme.try(:title)}] #{@opinion.issue.title}에 대한 의견 #{"`#{description}`" if description.present?}"
    prepare_meta_tags({
      title: full_description.html_safe,
      description: (view_context.strip_tags(@opinion.body).strip.truncate(150) if @opinion.body.present?),
      url: request.original_url}
    )
  end
end
