class ElectionCandidate < ApplicationRecord
  belongs_to :speaker, optional: true
  belongs_to :election, foreign_key: :election_slug, primary_key: :slug
end
