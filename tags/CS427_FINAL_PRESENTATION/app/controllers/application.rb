# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :authenticate
  
  
  #everything after is private
  private
  
  def authenticate
    if @session[:user] == nil && (params[:controller] != 'login' && !(params[:controller] == 'profile' && params[:action] == 'register'))
      redirect_to :controller => "login"
    end
  end
end
