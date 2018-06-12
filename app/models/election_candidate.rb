class ElectionCandidate < ApplicationRecord
  belongs_to :agent, optional: true
  belongs_to :election, foreign_key: :election_slug, primary_key: :slug
end
