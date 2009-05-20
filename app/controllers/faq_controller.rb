class FaqController < ApplicationController
before_filter :protect
  def index
      redirect_to hub_url
  end
  
  # Edit the user's FAQ.
    def edit
        @title = "Edit FAQ"
        @user = User.find(session[:user_id])
        @user.faq ||= Faq.new
        @faq = @user.faq
        if param_posted?(:faq)
        if @user.faq.update_attributes(params[:faq])
            flash[:notice] = "FAQ saved."
            redirect_to hub_url
        end
      end
    end
 end