class AgentMailer < ApplicationMailer
  def refresh_access_token(agent_id)
    @agent = Agent.find_by(id: agent_id)
    return if @agent.blank? or @agent.refresh_access_token.blank?

    mail(to: @agent.email,
      template_name: "refresh_access_token")
  end
end
