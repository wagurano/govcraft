class SentRequest < ApplicationRecord
  belongs_to :user
  belongs_to :speaker, counter_cache: true
end
