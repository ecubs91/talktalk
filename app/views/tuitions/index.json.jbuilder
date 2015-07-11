json.array!(@tuitions) do |tuition|
  json.extract! tuition, :id, :hours, :city, :note, :user_id, :tutor_profile_id
  json.url tuition_url(tuition, format: :json)
end
