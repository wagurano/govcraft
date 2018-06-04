class Voteaward::Promise < ActiveRecord::Base
  self.table_name = 'voteaward_promises'
  serialize :award_ids, Array
  belongs_to :voteaward_election, class_name: "Voteaward::Election", foreign_key: "voteaward_election_id"
  belongs_to :voteaward_candidate, class_name: "Voteaward::Candidate", foreign_key: "voteaward_candidate_id"
  belongs_to :voteaward_user, class_name: "Voteaward::User", foreign_key: "voteaward_user_id"
end
