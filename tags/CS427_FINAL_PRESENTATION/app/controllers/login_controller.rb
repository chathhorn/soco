class LoginController < ApplicationController
  def index
    @title = "Login"
  end
  
  def validate
    @user = User.authenticate(params[:user], params[:pass])
    if @user != nil
      @session[:user] = @user.id
      redirect_to :controller => 'profile'
    else
      flash[:error] = "Invalid user name or password."
      redirect_to :action => 'index'
    end
  end
  
  def logout
    @session[:user] = nil
    render :action => 'index'
  end
end
