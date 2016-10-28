class PagesController < ApplicationController
  def home
    @campaigns = Campaign.order('id DESC').limit(3)
    @following_issue = FollowingIssue.new
  end
end
