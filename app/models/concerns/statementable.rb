module Statementable
  extend ActiveSupport::Concern

  included do
    has_many :statements, as: :statementable
    has_and_belongs_to_many :dedicated_speakers, -> { distinct }, class_name: 'Speaker'
    has_many :action_targets, dependent: :destroy, as: :action_targetable
  end

  def speakers
    if action_targets.blank?
      dedicated_speakers
    else
      conditions = action_targets.map { |action_target|
        action_target.action_assignable.statementable_speakers(self) }
      conditions << Speaker.where(id: dedicated_speakers)
      Speaker.where.any_of(*conditions)
    end
  end

  def speakers_random(limit)
    speakers.order("RAND()").first(limit)
  end

  def speakable? speaker
    speakers.include? speaker
  end

  def spoken? speaker
    speakable?(speaker) and statement_of(speaker).try(:is_responed?)
  end

  def action_assignable_speakers_spoken(action_assignable)
    action_assignable.statementable_speakers(self).where(id: statements.responed_only.select(:speaker_id))
  end

  def action_assignable_speakers_unspoken(action_assignable)
    speakers_unspoken = action_assignable.statementable_speakers(self).where.not(id: statements.responed_only.select(:speaker_id))
    if action_assignable.speakers_unspoken_limit.present? and speakers_unspoken.count > action_assignable.speakers_unspoken_limit
      speakers_unspoken = speakers_unspoken.order("RAND()").first(action_assignable.speakers_unspoken_limit)
    else
      speakers_unspoken
    end
  end

  def statement_of speaker
    statements.find_by(speaker: speaker)
  end

  def total_action_assignables
    action_targets.map(&:action_assignable) + [DedicatedActionAssignee.new(self)]
  end
end
