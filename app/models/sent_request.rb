class SentRequest < ApplicationRecord
  belongs_to :user
  belongs_to :agent, counter_cache: true
  belongs_to :agenda
end
