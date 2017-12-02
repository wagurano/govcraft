module StatementableControlling
  extend ActiveSupport::Concern

  private

  def init_statementable(statementable)
    statementable.title_to_speaker = statementable.title
    statementable.message_to_speaker = statementable.body
  end

  def statementable_update_message_to_speaker(statementable)
    @statementable = statementable
    if @statementable.update_attributes(title_to_speaker: params[:title_to_speaker], message_to_speaker: params[:message_to_speaker])
      redirect_to @statementable
    else
      error_to_flash(@statementable)
      render 'statementables/edit_message_to_speaker'
    end
  end

  def statementable_edit_message_to_speaker(statementable)
    @statementable = statementable
    render 'statementables/edit_message_to_speaker'
  end

  def statementable_edit_speakers(statementable)
    if params[:q].present?
      @searched_speakers = Speaker.where('name like ?', "%#{params[:q]}%")
    end

    @statementable = statementable
    render 'statementables/edit_speakers'
  end

  def statementable_add_speaker(statementable)
    @speaker = Speaker.find_by(id: params[:speaker_id])
    render_404 and return if @speaker.blank?
    statementable.speakers << @speaker unless statementable.speakers.include?(@speaker)
    statementable.save
    redirect_to polymorphic_path([:edit_speakers, statementable], q: params[:q])
  end

  def statementable_new_comment_speaker(statementable)
    @statementable = statementable
    @comment = Comment.new
    if @statementable.respond_to? :message_to_speaker
      @comment.body = @statementable.message_to_speaker + "<p></p>"
    end

    if params[:speaker_id].present?
      @speaker = Speaker.find_by(id: params[:speaker_id])
      render_404 and return if @speaker.blank?

      render 'statementables/new_comment_speaker'
    else
      render 'statementables/new_comment_speaker_for_all'
    end
  end

  def statementable_update_statement_speaker(statementable)
    @statement_key = StatementKey.find_by(statement_id: params[:statement_id], key: params[:key])
    render_404 and return if @statement_key.blank?
    return if @statement_key.expired?

    @statement = @statement_key.statement

    if params[:stance].present?
      @statement.stance = params[:stance]
      @statement.save
    end

    @speaker = @statement.speaker
    @statementable = statementable
    render 'statementables/update_statement_speaker'
  end

  def statementable_remove_speaker(statementable)
    @speaker = Speaker.find_by(id: params[:speaker_id])
    render_404 and return if @speaker.blank?
    statementable.speakers.delete(@speaker) << @speaker if statementable.speakers.include?(@speaker)
    redirect_to polymorphic_path([:edit_speakers, statementable], q: params[:q])
  end
end
