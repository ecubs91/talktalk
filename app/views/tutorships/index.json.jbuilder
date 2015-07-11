json.array!(@tutorships) do |tutorship|
  json.extract! tutorship, :id, :tutor_id, :student_id, :subject_id, :accepted, :starting_date, :duration
  json.url tutorship_url(tutorship, format: :json)
end
