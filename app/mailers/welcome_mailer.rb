class WelcomeMailer < ActionMailer::Base
  default from: "youngtutors1230@gmail.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => @user.email, :subject => " 그루미에 오신 것을 환영합니다!")
  end

end
