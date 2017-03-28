class VotesController < ApplicationController
  include VoteHelper

  before_action :authenticate_user!, except: [:agree, :disagree]

  def agree
    @widget = params[:widget]
    fetch_votable
    choice(:agree)

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: @votable) }
    end
  end

  def disagree
    @widget = params[:widget]
    fetch_votable
    choice(:disagree)

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: @votable) }
    end
  end

  def cancel
    @widget = params[:widget]
    @votable ||= params[:votable_type].constantize.find params[:votable_id]
    @vote = @votable.fetch_vote_of(current_user)

    if @vote.present?
      errors_to_flash(@vote) unless @vote.destroy
    end

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: @votable) }
    end
  end

  private

  def choice(choice)
    if !user_signed_in? and anonymous_voted?(@votable)
      flash[:notice] = '로그인해서 투표한 경우만 바꿀 수 있습니다.'
      return
    end

    @vote = @votable.fetch_vote_of(current_user) if user_signed_in?

    if @vote.blank?
      @vote = @votable.votes.build(choice: choice, user: current_user)
      mark_anonymous_voted_poll(@votable, choice) unless user_signed_in?
      errors_to_flash(@vote) unless @votable.save
    elsif @vote.choice != choice
      @vote.update_attributes(choice: choice)
      errors_to_flash(@vote) unless @vote.save
    end

    @votable.reload
  end

  def fetch_votable
    @votable ||= params[:votable_type].constantize.find params[:votable_id]
  end
end
