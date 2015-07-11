json.array!(@tutor_profiles) do |tutor_profile|
  json.extract! tutor_profile, :id, :user_id, :university, :degree_subject, :teaching_subject, :location, :about_myself, :tutoring_approach, :teaching_experience, :extracurricular_interests
  json.url tutor_profile_url(tutor_profile, format: :json)
end
