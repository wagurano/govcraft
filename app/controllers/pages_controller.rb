class PagesController < ApplicationController
  def home
    @campaigns = Campaign.order('id DESC').limit(9)
  end

  def about
  end
end
