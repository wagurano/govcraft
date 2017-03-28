class FeedbacksController < ApplicationController
  before_filter :authenticate_user!

  def create
    @option = Option.find params[:option_id]
    survey = @option.survey

    if survey.open?
      feedbacks = survey.feedbacks.where user: current_user
      previous_feedback = feedbacks.find_by(option: @option)
      is_present_previous_feedback = previous_feedback.present?

      if survey.multi_selectable?
        if is_present_previous_feedback
          previous_feedback.destroy
        else
          feedback = create_feedback(@option)
        end
      else
        feedbacks.destroy_all
        unless is_present_previous_feedback
          feedback = create_feedback(@option)
        end
      end
    end

    @survey = survey
  end

  private

  def create_feedback(option)
    Feedback.create(user: current_user, option: option, survey: option.survey)
  end
end
