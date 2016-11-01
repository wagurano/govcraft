module ApplicationHelper
  def date_f(date)
    timeago_tag date, lang: :ko, limit: 3.days.ago
  end

  def screened(model, attr)
    model.screened? ? content_tag(:span, '신고로 인해 가려진 글입니다', class: "text-muted") : model.send(attr)
  end

  def smart_format(text, html_options = {}, options = {})
    parsed_text = simple_format(h(text), html_options, options).to_str
    raw(auto_link(parsed_text,
      html: {class: 'auto_link', target: '_blank'},
      link: :urls,
      sanitize: false))
  end
end
