json.title do
  json.text do
    json.headline @archive.title
  end
end

json.events @archive.documents do |document|
  if document.date.present?
    if document.image.file.present?
      json.media do
        json.url request.protocol + request.host_with_port + document.image_url(:lg)
      end
    end

    json.start_date do
      json.month document.date.strftime('%m')
      json.day document.date.strftime('%d')
      json.year document.date.strftime('%Y')
    end
    json.text do
      json.headline document.title
      json.text document.body + "<p>출처: #{document.source_url}</p>"
    end
  end
end