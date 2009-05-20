class SpecController < ApplicationController
  before_filter :protect
  
def index
redirect_to :controller => "user", :action => "index"
end
# Edit the user's spec.
  def edit
        @title = "Baguhin ang Impormasyon"
        @user = User.find(session[:user_id])
        @user.spec ||= Spec.new
        @spec = @user.spec
        if param_posted?(:spec)
        if @user.spec.update_attributes(params[:spec])
              flash[:notice] = "Na-saved na ang mga binago."
              redirect_to :controller => "user", :action => "index"
        end
        end
  end
end