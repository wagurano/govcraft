class SpecialsController < ApplicationController
  def voteaward2018
    limit = 20
    @speakers = Speaker.tagged_with("제7대_지방선거_예비후보", on: :positions).order("RAND()").first(5)
  end
end
