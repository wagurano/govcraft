class AgenciesController < ApplicationController
  def show
    @agency = Agency.find_by(slug: 'blue_house')
    @speakers = Speaker.tagged_with(@agency.position_list, on: :positions, any: true).order(:name)
    @petitions = Petition.where(id: PetitionsSpeakers.where(speaker: @speakers).select(:petition_id))
  end
end
