class PagesController < ApplicationController
  def home
    @projects = Project.recent
    @archives = Archive.recent
    @memorials = Memorial.recent
    @articles = Article.hot.limit(10)
  end

  def weekly
    @new_projects = Project.past_week
    @new_archives = Archive.past_week
    @new_memorials = Memorial.past_week
    @new_articles = Article.past_week

    @new_discussions = Discussion.past_week
    @new_petitions = Petition.past_week
    @new_polls = Poll.past_week
    @new_wikis = Wiki.past_week
    @new_events = Event.past_week
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
