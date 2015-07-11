class RegistrationsController < Devise::RegistrationsController

  def create
    super
    p "----------------------------------------"
    #WelcomeMailer.registration_confirmation(current_user).deliver
    p "----------------------------------------"
  end

end
