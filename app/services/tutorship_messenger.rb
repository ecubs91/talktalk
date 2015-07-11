class TutorshipMessenger

  def self.send_mailboxer_message(enquiry, tutor_id)
    new(enquiry, tutor_id)
  end 

  def initialize(enquiry, tutor_id)
    @enquiry = enquiry
    @student = enquiry.user
    @tutor  = User.find(tutor_id)

   send_the_enquiry

  end

  def send_the_enquiry
    subject = @enquiry.subject
    level = @enquiry.level
    location = @enquiry.location
    tuition_fee = @enquiry.tuition_fee
    note = @enquiry.note
    name = @enquiry.user.name

    Rails.logger.debug("services: #{@enquiry.user.name}")

    message_body = "Enquiry for: #{subject}, #{level}, #{location}, #{tuition_fee}, #{note} "

    message_subject = "#{name} has requested tution in #{subject}"

    @enquiry.user.send_message(@tutor,  message_body , message_subject)
   
  end
  

end