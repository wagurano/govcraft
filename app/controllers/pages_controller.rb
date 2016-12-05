class PagesController < ApplicationController
  def home
    @campaigns = Campaign.recent
    @archives = Archive.recent
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
