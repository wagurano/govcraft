class AgenciesController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def show
    @speakers = Speaker.tagged_with(@agency.position_list, on: :positions, any: true).order(:name)
    @petitions = Petition.where(id: PetitionsSpeakers.where(speaker: @speakers).select(:petition_id))
  end
end
