json.items @campaigns do |campaign|
  json.id campaign.id
  if campaign.issue.present?
    json.text "##{campaign.id} #{campaign.title} [이슈: #{campaign.issue.title}] "
  else
    json.text "##{campaign.id} #{campaign.title} [이슈: 관련이슈없음] "
  end
end
