class CommentMailer < ApplicationMailer
  def target_speaker(comment_id, speaker_id, statement_key_id)
    @comment = Comment.find_by(id: comment_id)
    return if @comment.blank?
    @statement_key = StatementKey.find_by(id: statement_key_id)
    return if @statement_key.blank?
    @speaker = Speaker.find_by(id: speaker_id)
    return if @speaker.blank?

    unless @speaker.try(:email).try(:present?)
      @comment.update_attributes(mailing: :fails)
      return
    end
    @comment.update_attributes(mailing: :sent)
    mail(to: @speaker.email,
      template_name: "target_speaker_#{@comment.commentable.class.name.underscore}")
  end
end
