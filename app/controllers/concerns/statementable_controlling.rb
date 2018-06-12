module StatementableControlling
  extend ActiveSupport::Concern

  private

  def init_statementable(statementable)
    statementable.title_to_agent = statementable.title
    statementable.message_to_agent = statementable.body
  end

  def statementable_update_message_to_agent(statementable)
    @statementable = statementable
    if @statementable.update_attributes(title_to_agent: params[:title_to_agent], message_to_agent: params[:message_to_agent])
      redirect_to @statementable
    else
      error_to_flash(@statementable)
      render 'statementables/edit_message_to_agent'
    end
  end

  def statementable_edit_message_to_agent(statementable)
    @statementable = statementable
    render 'statementables/edit_message_to_agent'
  end

  def statementable_edit_agents(statementable)
    if params[:q].present?
      @searched_agents = Agent.where('name like ?', "%#{params[:q]}%")
    end

    @statementable = statementable
    render 'statementables/edit_agents'
  end

  def statementable_add_agent(statementable)
    @agent = Agent.find_by(id: params[:agent_id])
    render_404 and return if @agent.blank?
    statementable.agents << @agent unless statementable.agents.include?(@agent)
    statementable.save
    redirect_to polymorphic_path([:edit_agents, statementable], q: params[:q])
  end

  def statementable_new_comment_agent(statementable)
    @statementable = statementable
    @comment = Comment.new
    if @statementable.respond_to? :message_to_agent
      @comment.body = @statementable.message_to_agent + "<p></p>"
    end

    if params[:agent_id].present?
      @agent = Agent.find_by(id: params[:agent_id])
      render_404 and return if @agent.blank?

      render 'statementables/new_comment_agent'
    else
      render 'statementables/new_comment_agent_for_all'
    end
  end

  def statementable_update_statement_agent(statementable)
    @statement_key = StatementKey.find_by(statement_id: params[:statement_id], key: params[:key])
    render_404 and return if @statement_key.blank?
    return if @statement_key.expired?

    @statement = @statement_key.statement

    if params[:stance].present?
      @statement.stance = params[:stance]
      @statement.save
    end

    @agent = @statement.agent
    @statementable = statementable
    render 'statementables/update_statement_agent'
  end

  def statementable_remove_agent(statementable)
    @agent = Agent.find_by(id: params[:agent_id])
    render_404 and return if @agent.blank?
    statementable.agents.delete(@agent) << @agent if statementable.agents.include?(@agent)
    redirect_to polymorphic_path([:edit_agents, statementable], q: params[:q])
  end
end
