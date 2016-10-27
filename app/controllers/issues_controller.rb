class IssuesController < ApplicationController
  load_and_authorize_resource

  def index
    @issue = Issue.order('title asc')
  end

  def show
  end
end
