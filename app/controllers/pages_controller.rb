class PagesController < ApplicationController
  def home
    @following_issue = FollowingIssue.new
  end
end
