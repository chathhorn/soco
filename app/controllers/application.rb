# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_soco_session_id'

  before_filter :authenticate
  
  before_filter :load_user

  #everything after is private
  private
  
  def authenticate
    if session[:user] == nil
      redirect_to :controller => "login"
    end
  end
  
  def load_user
    if session[:user] != nil
      @current_user = User.find session[:user]
    end
  end
end
