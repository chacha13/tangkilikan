# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
include ApplicationHelper

before_filter :check_authorization


# See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
 protect_from_forgery  :secret => 'b5272349ac1caa4234688b42fb9ee17a'

# Pick a unique cookie name to distinguish our session data from others'
session :session_key => '_tangkilikan_session_id'
    # Log a user in by authorization cookie if necessary.
    def check_authorization
          authorization_token = cookies[:authorization_token]
          if authorization_token and not logged_in?
              user = User.find_by_authorization_token(authorization_token)
              user.login!(session) if user
          end
    end


# Return true if a parameter corresponding to the given symbol was posted.
def param_posted?(sym)
  request.post? and params[sym]
 end

# Protect a page from unauthorized access.
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in first"
      redirect_to :controller => "user", :action => "login"
    return false
  end
end

# Paginate item list if present, else call default paginate method.
  def paginate(arg, options = {})
    if arg.instance_of?(Symbol) or arg.instance_of?(String)
      # Use default paginate function.
        collection_id = arg # arg is, e.g., :specs or "specs"
        super(collection_id, options)
    else
      # Paginate by hand.
        items = arg # arg is a list of items, e.g., users
        items_per_page = options[:per_page] || 10
        page = (params[:page] || 1).to_i
        result_pages = Paginator.new(self, items.length, items_per_page, page)
        offset = (page - 1) * items_per_page
        [result_pages, items[offset..(offset + items_per_page - 1)]]
    end
  end

end
