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
    @statementable.agent_section_title.presence || I18n.t("views.action_assignable.agent_section_title.default")
  end

  def response_section_title_as_action_assignable
    @statementable.agent_section_response_title.presence || I18n.t("views.action_assignable.agent_section_response_title.default")
  end

  def agents_unspoken_limit
    Float::INFINITY
  end
end
