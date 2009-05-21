require 'digest'
class User < ActiveRecord::Base

has_one :spec
has_one :faq
# Photos
  has_many :photos, :order => 'created_at DESC'

acts_as_ferret
include ApplicationHelper

attr_accessor :remember_me 
attr_accessor :current_password
attr_accessor :password_confirmation

# Max & min lengths for all fields
USER_NAME_MIN_LENGTH = 4
USER_NAME_MAX_LENGTH = 20
PASSWORD_MIN_LENGTH = 4
PASSWORD_MAX_LENGTH = 40
EMAIL_MAX_LENGTH = 50
# Text box sizes for display in the views
USER_NAME_SIZE = 20
PASSWORD_SIZE = 10
EMAIL_SIZE = 30
USERNAME_RANGE = USER_NAME_MIN_LENGTH...USER_NAME_MAX_LENGTH
validates_uniqueness_of :user_name, :email
validates_confirmation_of :password
validates_presence_of :password

# Return true if the password from params is correct.
def correct_password?(params)
    current_password = params[:user][:current_password]
    password == current_password
end
# Clear the password (typically to suppress its display in a view).
def clear_password!
  self.password = nil
  self.password_confirmation = nil
  self.current_password = nil
end
  
# Generate messages for password errors.
def password_errors(params)
# Use User model's valid? method to generate error messages
# for a password mismatch (if any).
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
# The current password is incorrect, so add an error message.
    errors.add(:current_password, "ay mali")
end
# Encrypt password before save
 
  def before_save
 
    if (self.salt == nil)
 
      self.salt = random_numbers(5)

      self.hashed_password = Digest::MD5.hexdigest(self.salt + self.password )
 
    else
 
       self.hashed_password = Digest::MD5.hexdigest(salt +  self.password )
 
    end
 
end
  # Verify password matches before login
 
  def password_matches?(password_to_match)
 
    self.hashed_password == Digest::MD5.hexdigest(self.salt + password_to_match)
 
  end
# Log a user in.                    
def login!(session)
    session[:user_id] = id
  end
# Log a user out.
def self.logout!(session, cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
end
# Clear the password (typically to suppress its display in a view).
def clear_password!
  self.password = nil
end

def name
spec.full_name.or_else(user_name)
end

def avatar
  Avatar.new(self)
end

# Remember a user for future login.
def remember!(cookies)
        cookie_expiration = 10.years.from_now
        cookies[:remember_me] = { :value => "1",
                :expires => cookie_expiration }
        self.authorization_token = unique_identifier
        save!
        cookies[:authorization_token] = { :value => authorization_token,
        :expires => cookie_expiration }
    end
    
    # Forget a user's login status.
    def forget!(cookies)
        cookies.delete(:remember_me)
        cookies.delete(:authorization_token)
    end
# Return true if the user wants the login status remembered.
  def remember_me?
      remember_me == "1"
  end
  
private
# Generate a unique identifier for a user.
    def unique_identifier
          Digest::SHA1.hexdigest("#{user_name}:#{password}")
    end

 
  def random_numbers(len)
 
    numbers = ("0".."9").to_a
 
    newrand = ""
 
    1.upto(len) { |i| newrand << numbers[rand(numbers.size - 1)] }
 
    return newrand
 
  end
 

end