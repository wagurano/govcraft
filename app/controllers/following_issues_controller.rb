class FollowingIssuesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    @following_issue.user = current_user
    unless @following_issue.save
      errors_to_flash(@following_issue)
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    unless @following_issue.destroy
      errors_to_flash(@issue)
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private

  def following_issue_params
    params.require(:following_issue).permit(:issue_id)
  end
end
