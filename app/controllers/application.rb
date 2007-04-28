# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_soco_session_id'

  before_filter :authenticate
  before_filter :get_flash_controller_id

  #everything after is private
  private
  
  def authenticate
    if session[:user] == nil
      redirect_to :controller => "login"
    end
  end

  def get_flash_controller_id
    @flash_controller_id = \
    case params[:controller]
    when 'profile': 2
    when 'friends'
      case params[:action]
      when 'list': 3
      when 'browse': 4
      end
    when 'long_term': 5
    when 'semester': 5
    when 'addons': 6
    else 0
    end
  end
end
