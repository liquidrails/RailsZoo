# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require_dependency 'password'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c394c8f32675d2ceed92272ca5d23c9e'

  include SimpleCaptcha::ControllerHelpers


protected

    def fetch_logged_in_user
	return unless session[:user_id]
	@current_user = Administrator.find_by_id(session[:user_id])
    end

	def logged_in?  #returns true if user is logged in
	  ! @current_user.nil?
	end

	helper_method  :logged_in?

	def login_required
	  return true if logged_in?
	    #session[:return_to] = request.request_uri
	  else
	    redirect_to new_cactus_session_path and return false
	end
   
        def master_login_required
            return true if logged_in? and @current_user.login =="daffy"
	    #session[:return_to] = request.request_uri
	  else
	    redirect_to new_cactus_session_path and return false
        end


	def fetch_logged_in_user
	  return unless session[:user_id]
	  @current_user = Administrator.find_by_id(session[:user_id])
	end

end
