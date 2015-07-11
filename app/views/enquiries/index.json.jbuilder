json.array!(@enquiries) do |enquiry|
  json.extract! enquiry, :id, :subject, :level, :location, :duration, :start_date, :tuition_fee, :note, :tutor_availablity, :tutorial_request
  json.url enquiry_url(enquiry, format: :json)
end
