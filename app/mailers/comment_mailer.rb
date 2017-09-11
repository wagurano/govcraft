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
      subject: "[우주당] \"#{@comment.commentable_title}\"에 대해 #{@comment.user_nickname}님이 의견을 보냅니다.")
  end
end
