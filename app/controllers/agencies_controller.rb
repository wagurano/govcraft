class AgenciesController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
  end

  def show
    @agents = Agent.tagged_with(@agency.position_list, on: :positions, any: true).order(:name)
    @petitions = Petition.where(id: PetitionsAgents.where(agent: @agents).select(:petition_id))
  end
end
