class LoggerJob 
  include SuckerPunch::Job
  
  def notification_mail_to_multiple_users(subject,message,users)
  	users.each do |user|
    	MessageMailer.send_notification_mailer_to_multiple_users(subject,message,user)
    end	
  end
end
