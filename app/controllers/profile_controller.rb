class ProfileController < ApplicationController
  helper :avatar
def index
  @title = "Tangkilikan Profiles"
end

 
def show
    @hide_edit_links = true
    user_name = params[:user_name]
    @user = User.find_by_user_name(user_name)
    if @user
        @title = "My Tangkilikan Profile for #{user_name}"
        @spec = @user.spec ||= Spec.new
        @faq = @user.faq ||= Faq.new
    else
        flash[:notice] = "No user #{user_name} at Tangkilikan!"
        redirect_to :action => "index"
    end
 end

end