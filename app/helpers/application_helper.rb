module ApplicationHelper
  def date_f(date)
    timeago_tag date, lang: :ko, limit: 3.days.ago
  end
end
