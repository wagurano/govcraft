class Voteaward::Candidate < ActiveRecord::Base
  self.table_name = 'voteaward_candidates'
  belongs_to :voteaward_election, class_name: "Voteaward::Election", foreign_key: "voteaward_election_id"
end
