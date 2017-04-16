module FeedbackHelper
  def mark_anonymous_selected_option(option)
    updated = selected_surveys
    if updated["#{option.survey.id}"].blank?
      updated["#{option.survey.id}"] = [option.id]
    else
      updated["#{option.survey.id}"] << option.id
    end

    begin
      cookies.permanent.signed[:oasis_tiger] = JSON.generate(updated)
    rescue ActionDispatch::Cookies::CookieOverflow => e
      flash[:error] = t('errors.messages.no_more_anonymous')
      raise ActiveRecord::Rollback
    end
  end

  def mark_anonymous_unselected_option(survey, option = nil)
    updated = selected_surveys
    if option.blank?
      updated["#{survey.id}"] = nil
    else
      if updated["#{survey.id}"].any?
        updated["#{survey.id}"].reject! { |id| id == option.id }
      end
    end
    begin
      cookies.permanent.signed[:oasis_tiger] = JSON.generate(updated)
    rescue ActionDispatch::Cookies::CookieOverflow => e
      flash[:error] = t('errors.messages.no_more_anonymous')
      raise ActiveRecord::Rollback
    end
  end

  def fetch_anonymous_selected_option_ids(survey)
    selected_surveys["#{survey.id}"]
  end

  def option_selected?(option, current_user)
    if user_signed_in?
      option.selected?(current_user)
    else
      fetch_anonymous_selected_option_ids(option.survey).try(:include?, option.id)
    end
  end

  private

  def selected_surveys
    cookie_selected_surveys = cookies.permanent.signed[:oasis_tiger]
    cookie_selected_surveys.present? ? JSON.parse(cookie_selected_surveys) : {}
  end
end
