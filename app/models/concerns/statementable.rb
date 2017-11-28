module Statementable
  extend ActiveSupport::Concern

  included do
    has_many :statements, as: :statementable
  end

  def speakers? speaker
    speakers.include? speaker
  end
end
