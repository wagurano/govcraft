class SpecialsController < ApplicationController
  def voteaward2018
    limit = 20
    @election = Election.of_slug(Election::SLUG_20180613)
    @agents = @election.agents_moderatly(4 * 2)

    @petitions = Petition.where(special_slug: Special::SLUG_VOTEAWARD2018)
    @form_petition = Petition.new(special_slug: Special::SLUG_VOTEAWARD2018)
  end
end
