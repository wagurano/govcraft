class AgenciesController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
  end

  def show
    @petitions = Petition.where(id: AgentsPetitions.where(agent: @agents).select(:petition_id))
  end

  def agents
    @all_agents = @agency.agents
    if params[:position_name]
      @agents = @agency.agents.of_position_names(params[:position_name]).order(:name)
    else
      @agents = @agency.agents.order(:name)
    end
    @agents = @agents.page(params[:page])
  end
end
