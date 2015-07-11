class MessagesController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]

  def new
    @similar_users = params[:similar_users] || []
    if current_user.present?
      @user = User.find(params[:user])
      @message = current_user.messages.new
    else
      flash[:error] = "로그인이 필요로 합니다."
      redirect_to new_user_session_path
    end
  end
 
  def create
    if !current_user
      redirect_to pages_require_sign_in_path
    else
      send_to_all = params[:accept] # check the message send to all or one
      if send_to_all
        users = JSON.parse(params[:similar_users]) << params[:user].to_i
        users.each do |user|
          recipient = User.find(user)
          message_body = "#{recipient.first_name}님, #{params[:body]}"
          current_user.send_message(recipient, message_body, params[:subject])
          flash[:notice] = "Message has been sent! You will have a reply within the next 24 hours."
        end
      else
        @recipient = User.find(params[:user])
        message_body = "#{@recipient.first_name}님, #{params[:body]}"
        current_user.send_message(@recipient, message_body, params[:subject])
        flash[:notice] = "메세지가 전송 되었습니다. 24시간 내로 답장 받으실 겁니다."
      end
      redirect_to :conversations
    end 
  end
end