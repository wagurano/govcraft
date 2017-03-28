class OpinionsController < ApplicationController
  load_and_authorize_resource

  def vote_widget
    @votable = @opinion
    render layout: 'strip_without_footer'
  end
end
