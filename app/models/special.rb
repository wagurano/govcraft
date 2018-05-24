class Special
  SLUG_VOTEAWARD2018 = 'voteaward2018'

  def self.build_petition(petition)
    if petition.special_slug == Special::SLUG_VOTEAWARD2018
      petition.signs_goal_count = 0
    end
    petition.action_targets.build(action_assignable: Election.of_slug(Election::SLUG_20180613))
  end

  def self.decorate_speaker_organization(specialable, speaker)
    if specialable.respond_to?(:special_slug) and specialable.special_slug == Special::SLUG_VOTEAWARD2018
      election_candidate = Election.of_slug(Election::SLUG_20180613).election_candidates.find_by(speaker_id: speaker.id)
      if election_candidate.present?
        return "#{election_candidate.election_category}\n#{election_candidate.area_division}"
      end
    end

    speaker.organization
  end
end
