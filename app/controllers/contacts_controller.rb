class ContactsController < ApplicationController

	def new
    @contact = Contact.new
  end

  def create
    if MessageMailer.send_me_message(params[:contact])
      flash[:notice] = 'Thank you for your message. Our support team will get back to you within 24 hours!'
    else
      flash[:error] = 'We cannot send the message because there is a problem with your email address. Please check that you have a valid email address.'
    end
  end

end
