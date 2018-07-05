class DedicatedActionAssignee
  def initialize(statementable)
    @statementable = statementable
  end

  def statementable_agents(statementable)
    statementable.dedicated_agents
  end

  def statementable_agents_moderatly(statementable, limit)
    statementable_agents(statementable)
  end

  def section_title_as_action_assignable
    return if @statementable.dedicated_agents.empty?
    first_agent = @statementable.dedicated_agents.first
    return "#{first_agent.organization} #{first_agent.name}님#{(" 이외 #{@statementable.dedicated_agents.count - 1}분" if @statementable.dedicated_agents.count > 1)}"
  end

  def response_section_title_as_action_assignable
    @statementable.agent_section_response_title.presence || I18n.t("views.action_assignable.agent_section_response_title.default")
  end

  def agents_unspoken_limit
    Float::INFINITY
  end
end
