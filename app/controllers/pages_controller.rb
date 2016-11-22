class PagesController < ApplicationController
  def home
    @campaigns = Campaign.order('id DESC').limit(9)
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
end
