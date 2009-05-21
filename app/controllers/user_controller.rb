require 'digest/sha1'
class UserController < ApplicationController
 include ApplicationHelper 
 helper :profile, :avatar
 before_filter :protect, :only => [ :edit ] 

  def index
@title = "Tangkilikan User Hub"
@user = User.find(session[:user_id])
@spec = @user.spec ||= Spec.new
@faq = @user.faq ||= Faq.new
end
  
  def register
      @title = "Register"
      if param_posted?(:user)
      @user = User.new(params[:user])
      if @user.save
      @user.login!(session)
      flash[:notice] = "User #{@user.user_name} created!"
      redirect_to_forwarding_url
      else
        @user.clear_password!
      end
    end
   end

  def login
      @title = "Log in sa Tangkilikan"
      if request.get?
          @user = User.new(:remember_me => remember_me_string)
       
       elsif param_posted?(:user)
          @user = User.new(params[:user])
           user = User.find_by_user_name(@user.user_name)
 

      if user and user.password_matches?(@user.password)
          user.login!(session)
          @user.remember_me? ? user.remember!(cookies) : user.forget! (cookies)
          flash[:notice] = "Si #{user.user_name} ay nag-login!"
          redirect_to_forwarding_url
      else
          @user.clear_password!
          flash[:notice] = "Mali ang username/password combination"
      end
    end
end
  
    def logout
     User.logout!(session, cookies)
      flash[:notice] = "Logged out"
      redirect_to :action => "index", :controller => "site"
       
    end     

# Edit the user's basic info.
def edit
        @title = "Baguhin ang account info"
        @user = User.find(session[:user_id])
        if param_posted?(:user)
            attribute = params[:attribute]
        case attribute
        when "email"
              try_to_update @user, attribute
        when "password"
        if @user.correct_password?(params)
          try_to_update @user, attribute
        else
          @user.password_errors(params)
      end
    end
end
  # For security purposes, never fill in password fields.
  @user.clear_password!
end
private
# Try to update the user, redirecting if successful.
def try_to_update(user, attribute)
    if user.update_attributes(params[:user])
        flash[:notice] = "Account info ni ay #{attribute} nabago."
        redirect_to :action => "index"
    end
end
  # Protect a page from unauthorized access.  
  def protect
      unless logged_in?
          session[:protected_page] = request.request_uri
          flash[:notice] = "Kailngan mag-login muna"
          redirect_to :action => "login"
      return false
      end
  end

# Redirect to the previously requested URL (if present)
def redirect_to_forwarding_url
  if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
  else
      redirect_to :action => "index"
   end 
   end

# Return true if a parameter corresponding to the given symbol was poste
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
  
  # Return a string with the status of the remember me checkbox.
def remember_me_string
    cookies[:remember_me] || "0"
end
end