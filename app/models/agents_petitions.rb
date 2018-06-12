class AgentsPetitions < ApplicationRecord
  belongs_to :agent
  belongs_to :petition
end
