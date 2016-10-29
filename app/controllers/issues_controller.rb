class IssuesController < ApplicationController
  load_and_authorize_resource

  def index
    @issues = Issue.all
  end

  def show
  end
end
