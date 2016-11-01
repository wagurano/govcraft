class PagesController < ApplicationController
  def home
    @campaigns = Campaign.order('id DESC').limit(3)
  end
end
