class IssuesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @issue = Issue.order('title asc')
  end
end
