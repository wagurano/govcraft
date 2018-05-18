class ElectionCandidate < ApplicationRecord
  belongs_to :speaker, optional: true
end
