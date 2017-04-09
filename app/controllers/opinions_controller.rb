class OpinionsController < ApplicationController
  load_and_authorize_resource
  protect_from_forgery except: :vote_widget

  def show
    redirect_to speaker_path(@opinion.speaker, anchor: "issue_#{@opinion.issue.id}")
  end

  def vote_widget
    @votable = @opinion
    render layout: 'strip_without_footer'
  end
end
