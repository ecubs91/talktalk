json.array!(@questions) do |question|
  json.extract! question, :id, :subject, :question, :text
  json.url question_url(question, format: :json)
end
