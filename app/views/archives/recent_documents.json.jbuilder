json.array! @documents.each do |document|
  json.id document.id
  json.title document.title
  json.url archive_document_url(document)
end
