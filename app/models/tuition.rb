class Tuition < ActiveRecord::Base
  validates :hours, presence: true
  belongs_to :tutor_profile
  belongs_to :user
  after_create :leave_message

  def leave_message

    flag = false
    user = self.user
    tutor_profile_user = self.tutor_profile.user
    conversation = nil

    user.mailbox.conversations.each do |conv|
      if conv.participants.include?(tutor_profile_user)
        conversation = conv
        break
      end
    end

    if conversation.nil?
      # no conversation found
      user.send_message(tutor_profile_user, "Hi #{tutor_profile_user.first_name} #{tutor_profile_user.last_name},\n\n I have booked #{self.hours} hours with you. \n\n My email is : #{user.email}.", "Booking for tuition.")
    else
      user.reply_to_conversation(conversation, "Hi #{tutor_profile_user.first_name} #{tutor_profile_user.last_name},\n\n I have booked #{self.hours} hours with you. \n\n My email is : #{user.email}.")
      # conversation found
    end

  end

end
