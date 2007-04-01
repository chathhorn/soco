class LoginController < ApplicationController
  skip_filter :authenticate

  def index
    if session[:user]
      redirect_to :controller => 'profile', :action => 'show'
    end

    @title = "Login"
  end
  
  def validate
    @user = User.authenticate(params[:user], params[:pass])
    if @user != nil
      session[:user] = @user.id
      session[:username] = @user.username
      redirect_to :controller => 'profile'
    else
      flash[:error] = "Invalid user name or password."
      redirect_to :action => 'index'
    end
  end
  
  def logout
    reset_session
    flash[:alert] = "Logged out" 
    redirect_to :action => "index" 
  end
end
