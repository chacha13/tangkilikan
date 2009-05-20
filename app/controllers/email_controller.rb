class EmailController < ApplicationController

  def remind
    @title = "Mail me my login information"
    if param_posted?(:user)
      email = params[:user][:email]
      user = User.find_by_email(email)
    if user
      UserMailer.deliver_reminder(user)
      flash[:notice] = "Login information was sent."
      redirect_to :action => "index", :controller => "site"
    else
      flash[:notice] = "There is no user with that email address."
    end
  end
  end
end
   
