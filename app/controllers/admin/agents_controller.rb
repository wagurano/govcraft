class Admin::AgentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @agents = Agent.page(params[:page])
    @agents = @agents.search_for(params[:q]) if params[:q].present?
  end

  def create
    if @agent.save
      redirect_to admin_agents_path
    else
      render 'new'
    end
  end

  def update
    if @agent.update(agent_params)
      redirect_to admin_agents_path
    else
      render 'edit'
    end
  end

  def destroy
    @agent.destroy
    redirect_to admin_agents_path
  end

  private

  def agent_params
    params.require(:agent).permit(:image, :name, :organization, :category, :position_name_list, :email, :twitter, :public_site, :election_region)
  end
end
