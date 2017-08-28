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
    @polls = Poll.where(id: [90, 91, 92, 93, 94])
  end
end
