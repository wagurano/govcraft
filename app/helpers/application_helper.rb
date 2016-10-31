module ApplicationHelper
  def date_f(date)
    timeago_tag date, lang: :ko, limit: 3.days.ago
  end

  def screened(model, attr)
    model.screened? ? content_tag(:span, '신고로 인해 가려진 글입니다', class: "text-muted") : model.send(attr)
  end
end
