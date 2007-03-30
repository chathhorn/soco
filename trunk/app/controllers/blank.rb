# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class BlankController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_soco_session_id'

  before_filter :authenticate
  
  
  #everything after is private
  private
  
  def authenticate
    if session[:user] == nil && (params[:controller] != 'login' && !(params[:controller] == 'profile' && params[:action] == 'register'))
      redirect_to :controller => "login"
    end
  end
end
