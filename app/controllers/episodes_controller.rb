class EpisodesController < ApplicationController
  before_action :authenticate_user!, only: :change2020_polls

  def change2020
    @project = Project.find_by slug: :rebootkorea
    change2020_fetch_polls
    render layout: 'strip'
  end

  def change2020_polls
    @project = Project.find_by slug: :rebootkorea
    change2020_fetch_polls
    render layout: 'strip'
  end

  private

  def change2020_fetch_polls
    # @polls = Poll.where(id: [103, 104, 105, 106, 107])
    @polls = Poll.where(id: (112..123).to_a)
  end
end
