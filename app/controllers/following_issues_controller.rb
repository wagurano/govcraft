class FollowingIssuesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    ActiveRecord::Base.transaction do
      @issue = Issue.find_or_create_by title: @following_issue.issue_title
      if @issue.persisted?
        current_user.following_issues.build(issue: @issue)
        unless current_user.save
          errors_to_flash(current_user)
        end
      else
        errors_to_flash(@issue)
      end
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    unless @following_issue.destroy
      errors_to_flash(@issue)
    end
    redirect_to root_path
  end

  private

  def following_issue_params
    params.require(:following_issue).permit(:issue_title)
  end
end
