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

  def asset_data_base64(path)
    content, content_type = parse_asset(path)
    base64 = Base64.encode64(content).gsub(/\s+/, "")
    "data:#{content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def parse_asset(path)
    if Rails.application.assets
      asset = Rails.application.assets.find_asset(path)
      throw "Could not find asset '#{path}'" if asset.nil?
      return asset.to_s, asset.content_type
    else
      name = Rails.application.assets_manifest.assets[path]
      throw "Could not find asset '#{path}'" if name.nil?
      content_type = MIME::Types.type_for(name).first.content_type
      content = open(File.join(Rails.public_path, 'assets', name)).read
      return content, content_type
    end
  end
end
