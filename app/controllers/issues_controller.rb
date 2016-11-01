class IssuesController < ApplicationController
  load_and_authorize_resource

  def index
    @issues = Issue.all
    @following_issue = FollowingIssue.new
  end

  def show
  end
end
