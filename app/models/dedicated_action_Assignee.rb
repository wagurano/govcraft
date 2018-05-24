class DedicatedActionAssignee
  def initialize(statementable)
    @statementable = statementable
  end

  def statementable_speakers(statementable)
    statementable.dedicated_speakers
  end

  def statementable_speakers_moderatly(statementable, limit)
    statementable_speakers(statementable)
  end

  def section_title_as_action_assignable
    @statementable.speaker_section_title.presence || I18n.t("views.action_assignable.speaker_section_title.default")
  end

  def response_section_title_as_action_assignable
    @statementable.speaker_section_response_title.presence || I18n.t("views.action_assignable.speaker_section_response_title.default")
  end

  def speakers_unspoken_limit
    Float::INFINITY
  end
end
