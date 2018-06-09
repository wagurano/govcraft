json.items @issues do |issue|
  json.id issue.id
  json.text issue.title
end
