class FeedbacksController < ApplicationController
  include FeedbackHelper

  def create
    @option = Option.find params[:option_id]
    survey = @option.survey

    if survey.open?
      ActiveRecord::Base.transaction do
        if user_signed_in?
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
        else
          unless @option.survey.anonymous_feedbackable?
            render 'login_alert.js.erb'
            return
          end

          @previous_selected_options = @option.survey.options.where(id: fetch_anonymous_selected_option_ids(@option.survey))
          if survey.multi_selectable?
            if @previous_selected_options.include? @option
              @option.decrement(:anonymous_feedbacks_count)
              mark_anonymous_unselected_option(@option.survey, @option)
            else
              @option.increment(:anonymous_feedbacks_count)
              mark_anonymous_selected_option(@option)
            end
          else
            @option.survey.options.update_all(anonymous_feedbacks_count: 0)
            mark_anonymous_unselected_option(@option.survey)
            if @previous_selected_options.empty? or !@previous_selected_options.include? @option
              @option.increment(:anonymous_feedbacks_count)
              mark_anonymous_selected_option(@option)
            end
          end
          @option.save
        end
      end
    end

    @option.reload
    @survey = survey
  end

  private

  def create_feedback(option)
    Feedback.create(user: current_user, option: option, survey: option.survey)
  end
end
