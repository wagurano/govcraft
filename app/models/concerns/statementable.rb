module Statementable
  extend ActiveSupport::Concern

  included do
    has_many :statements, as: :statementable
    has_and_belongs_to_many :dedicated_agents, -> { distinct }, class_name: 'Agent'
    has_many :action_targets, dependent: :destroy, as: :action_targetable
  end

  def agents
    if action_targets.blank?
      dedicated_agents
    else
      conditions = action_targets.map { |action_target|
        action_target.action_assignable.statementable_agents(self) }
      conditions << Agent.where(id: dedicated_agents)
      Agent.where.any_of(*conditions)
    end
  end

  def agents_random(limit)
    agents.order("RAND()").first(limit)
  end

  def speakable? agent
    agents.include? agent
  end

  def spoken? agent
    speakable?(agent) and statement_of(agent).try(:is_responed?)
  end

  def action_assignable_agents_spoken(action_assignable)
    action_assignable.statementable_agents(self).where(id: statements.responed_only.select(:agent_id))
  end

  def action_assignable_agents_unspoken(action_assignable)
    agents_unspoken = action_assignable.statementable_agents(self).where.not(id: statements.responed_only.select(:agent_id))
    if action_assignable.agents_unspoken_limit.present? and agents_unspoken.count > action_assignable.agents_unspoken_limit
      agents_unspoken = agents_unspoken.order("RAND()").first(action_assignable.agents_unspoken_limit)
    else
      agents_unspoken
    end
  end

  def statement_of agent
    statements.find_by(agent: agent)
  end

  def total_action_assignables
    action_targets.map(&:action_assignable) + [DedicatedActionAssignee.new(self)]
  end
end
