class VotesController < ApplicationController
  include VoteHelper

  before_action :authenticate_user!, except: [:agree, :disagree]

  def agree
    fetch_poll
    choice(:agree)

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: @poll) }
    end
  end

  def disagree
    fetch_poll
    choice(:disagree)

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: @poll) }
    end
  end

  def cancel
    @poll = Poll.find params[:poll_id]
    @vote = @poll.fetch_vote_of(current_user)

    if @vote.present?
      errors_to_flash(@vote) unless @vote.destroy
    end

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: @poll) }
    end
  end

  private

  def choice(choice)
    if !user_signed_in? and anonymous_voted?(@poll)
      flash[:notice] = '로그인해서 투표한 경우만 바꿀 수 있습니다.'
      return
    end

    @vote = @poll.fetch_vote_of(current_user) if user_signed_in?

    if @vote.blank?
      @vote = @poll.votes.build(choice: choice, user: current_user)
      mark_anonymous_voted_poll(@poll, choice) unless user_signed_in?
      errors_to_flash(@vote) unless @poll.save
    elsif @vote.choice != choice
      @vote.update_attributes(choice: choice)
      errors_to_flash(@vote) unless @vote.save
    end

    @poll.reload
  end

  def fetch_poll
    @poll ||= Poll.find params[:poll_id]
  end
end
