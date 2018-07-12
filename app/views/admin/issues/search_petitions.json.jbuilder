json.items @petitions do |petition|
  json.id petition.id
  if petition.issue.present?
    json.text "##{petition.id} #{petition.title} [이슈: #{petition.issue.title}] "
  else
    json.text "##{petition.id} #{petition.title} [이슈: 관련이슈없음] "
  end
end
