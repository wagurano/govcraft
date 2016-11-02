class VotesController < ApplicationController
  include VoteHelper

  before_action :authenticate_user!, except: [:agree, :disagree]

  def agree
    fetch_poll
    choice(:agree) if votable?(@poll)
    redirect_back(fallback_location: @poll)
  end

  def disagree
    fetch_poll
    choice(:disagree) if votable?(@poll)
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

  def votable?(poll)
    user_signed_in? or !anonymous_voted?(poll)
  end

  def choice(choice)
    @vote = @poll.fetch_vote_of(current_user) if user_signed_in?

    if @vote.blank?
      @vote = @poll.votes.build(choice: choice, user: current_user)
      mark_anonymous_voted_poll(@poll, choice) unless user_signed_in?
      errors_to_flash(@vote) unless @poll.save
    elsif @vote.choice != choice
      @vote.update_attributes(choice: choice)
      errors_to_flash(@vote) unless @vote.save
    end
  end

  def fetch_poll
    @poll ||= Poll.find params[:poll_id]
  end
end
