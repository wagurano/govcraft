class CommentMailer < ApplicationMailer
  def target_agent(comment_id, agent_id, statement_key_id)
    metadata['comment_id'] = comment_id
    metadata['agent_id'] = agent_id
    @comment = Comment.find_by(id: comment_id)
    return if @comment.blank?
    @statement_key = StatementKey.find_by(id: statement_key_id)
    return if @statement_key.blank?
    @agent = Agent.find_by(id: agent_id)
    return if @agent.blank?

    unless @agent.try(:email).try(:present?)
      @comment.update_attributes(mailing: :fails)
      return
    end
    @comment.update_attributes(mailing: :sent)
    mail(to: @agent.email,
      template_name: "target_agent_#{@comment.commentable.class.name.underscore}",
      tag: "order")
  end
end
