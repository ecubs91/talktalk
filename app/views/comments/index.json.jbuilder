json.array!(@comments) do |comment|
  json.extract! comment, :id, :user_id, :blog_id, :reply
  json.url comment_url(comment, format: :json)
end
