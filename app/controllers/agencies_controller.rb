class AgenciesController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
  end

  def show
    @petitions = Petition.where(id: AgentsPetitions.where(agent: @agents).select(:petition_id))
  end

  def agents
    if params[:position]
      @agents = Agent.tagged_with(params[:position], on: :positions, any: true).order(:name)
    else
      @agents = Agent.order(:name)
    end
    @agents = @agents.page(params[:page])
  end
end
