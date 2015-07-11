class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :file,      :attachment => true

  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "A question from Young Tutors web",
      :to => "harrylee1230@gmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end

  def contact
    @contact = Contact.new(params[:id]),
    @contact.deliver
  end
end