class AvatarController < ApplicationController
before_filter :protect

  def index
      redirect_to hub_url
  end

  def upload
  @title = "Upload Your Avatar"
  @user = User.find(session[:user_id])
  if param_posted?(:avatar)
      image = params[:avatar][:image]
      @avatar = Avatar.new(@user, image)
  if @avatar.save
    flash[:notice] = "Your avatar has been uploaded."
    redirect_to hub_url
  end
  end
end

  # Delete the avatar.
def delete
user = User.find(session[:user_id])
user.avatar.delete
flash[:notice] = "Your avatar has been deleted."
redirect_to hub_url
end
end

