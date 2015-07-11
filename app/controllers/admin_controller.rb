class AdminController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def notify_users

  end

  def send_mail_to_users
    name = params[:name]
    subject = params[:subject]
    message = params[:message]

    users = nil
    case(params[:selection_type])
      when "all_users"
        users = User.find(User.pluck(:id)).uniq
      when "users_with_tutor_profile"
        users = User.find(TutorProfile.pluck(:user_id).uniq).uniq
      when "users_without_tutor_profile"
        users = User.find(User.pluck(:id)-TutorProfile.pluck(:user_id).uniq).uniq
    end

    # emails = []
    # users.each {|user| emails << user.email }
    LoggerJob.new.async.notification_mail_to_multiple_users(subject,message,users)
    flash[:notice] = "The message will be sent..!!"
    redirect_to :back
    # if MessageMailer.send_notification_mailer_to_multiple_users(subject,message,emails)
      # flash[:notice] = "The message is sent successfully..!!"
    #   redirect_to :back
    # else
    #   flash[:error] = "We are not able to send message.."
    #   redirect_to :back
    # end
  end

  def run_script
    User.where(:email => "harrylee1230@gmail.com").first.update_attributes(:authority => "admin")
  end

end
