class PetitionsSpeakers < ApplicationRecord
  belongs_to :speaker
  belongs_to :petition
end
