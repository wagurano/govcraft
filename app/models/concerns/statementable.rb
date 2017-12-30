module Statementable
  extend ActiveSupport::Concern

  included do
    has_many :statements, as: :statementable
    has_and_belongs_to_many :speakers, -> { uniq }
  end

  def speakable? speaker
    speakers.include? speaker
  end

  def speeched? speaker
    speakable?(speaker) and statement_of(speaker).try(:is_responed?)
  end

  def statement_of speaker
    statements.find_by(speaker: speaker)
  end
end
