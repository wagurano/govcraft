class PagesController < ApplicationController
  def home
    @campaigns = Campaign.recent
    @archives = Archive.recent
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
end
