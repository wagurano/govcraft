class PagesController < ApplicationController
  def home
    @campaigns = Campaign.limit(3)
    @following_issue = FollowingIssue.new
  end
end
