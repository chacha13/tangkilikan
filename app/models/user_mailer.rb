class UserMailer < ActionMailer::Base


  def reminder(user)
      @subject = 'Ang iyong Login Information sa Tangkilikan.com'
      @body = {}
      # Give body access to the user information.
      @body["user"] = user
      @recipients = user.email
      @from = 'Tangkilikan <webmaster@tangkilikan.com>'
  end
  
end