module Statementable
  extend ActiveSupport::Concern

  included do
    has_many :statements, as: :statementable
    has_and_belongs_to_many :speakers, -> { uniq }
  end

  def speakers? speaker
    speakers.include? speaker
  end
end
