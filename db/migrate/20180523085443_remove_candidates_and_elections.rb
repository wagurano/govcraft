class RemoveCandidatesAndElections < ActiveRecord::Migration[5.0]
  def change
    rename_table :candidates, :deprecated_candidates
    rename_table :elections, :deprecated_elections
  end
end
