class AgentsCampaigns < ApplicationRecord
  belongs_to :agent
  belongs_to :campaign
end
