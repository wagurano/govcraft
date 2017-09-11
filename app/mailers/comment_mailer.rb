class CommentMailer < ApplicationMailer
  def target_speaker(comment_id)
    @comment = Comment.find_by(id: comment_id)
    return if @comment.blank?

    @speaker = @comment.target_speaker
    unless @speaker.try(:email).try(:present?)
      @comment.update_attributes(mailing: :fails)
      return
    end
    @comment.update_attributes(mailing: :sent)

    mail(to: @speaker.email,
      template_name: "target_speaker_#{@comment.commentable.class.name.underscore}")
  end
end
