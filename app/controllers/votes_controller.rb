class VotesController < ApplicationController
  before_action :authenticate_user!

  def agree
    choice(:agree)
    redirect_back(fallback_location: @poll)
  end

  def disagree
    choice(:disagree)
    redirect_back(fallback_location: @poll)
  end

  def cancel
    @poll = Poll.find params[:poll_id]
    @vote = @poll.fetch_vote_of(current_user)

    if @vote.present?
      errors_to_flash(@vote) unless @vote.destroy
    end
    redirect_back(fallback_location: @poll)
  end

  private

  def choice(choice)
    @poll = Poll.find params[:poll_id]
    @vote = @poll.fetch_vote_of(current_user)

    if @vote.blank?
      @vote = @poll.votes.build(choice: choice, user: current_user)
      errors_to_flash(@poll) unless @poll.save
    elsif @vote.choice != choice
      @vote.update_attributes(choice: choice)
      errors_to_flash(@vote) unless @vote.save
    end
  end
end
