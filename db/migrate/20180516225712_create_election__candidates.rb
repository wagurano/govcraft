class CreateElectionCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :election_candidates do |t|
      t.references :speaker, index: true
      t.string :candidate_category
      t.string :district_name
      t.string :party
      t.string :image_url
      t.string :name
      t.string :election_slug
      t.string :election_category
      t.string :election_code
      t.string :area_division
      t.string :area_division_code
      t.string :district_slug
      t.string :district_code
    end
  end
end
