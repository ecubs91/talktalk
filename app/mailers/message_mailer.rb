class MessageMailer < ActionMailer::Base

  def send_me_message(contact)
    @name = contact["name"]
    @message = contact["message"]
    @email = contact["email"]
    mail(:from => contact["email"],:to => "support@gurume.co.uk", :subject => "문의 이메일").deliver
  end

  def send_notification_mailer_to_multiple_users(subject,message,user)
    @user = user
    @message = message
    mail(:from => "test@youngtutors.com",:to => user.email, :subject => subject).deliver
  end

  def send_notification_on_tutor_create(email,tutor_profile)
    @tutor_profile = tutor_profile
    mail(:from => "test@youngtutors.com",:to => email, :subject => "그루미 선생님이 되신걸 환영합니다!").deliver
  end

  def send_invitation_for_review(email,first_name,last_name,message,url,tp)
    @first_name = first_name
    @last_name = last_name
    @message = message
    @url = url
    @tutor_profile = tp
    mail(:from => "test@youngtutors.com",:to => email, :subject => "[그루미] 수업 후기 부탁 드립니다!").deliver
  end

  def send_user_specific_request_for_review(email,url,tp)
    @url = url
    @tutor_profile = tp
    mail(:from => "test@youngtutors.com",:to => email, :subject => "후기 요청이 성공적으로 되었습니다").deliver
  end

end