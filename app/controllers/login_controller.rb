class LoginController < ApplicationController
  def index
  end
  def validate
    @user = User.authenticate(params[:user], params[:pass])
    if @user != nil
      @session[:user] = @user.id
      redirect_to(:controller => 'long_term')
    else
      render :action => 'index'
      flash[:error] = "Invalid user name or password."
    end
  end  
end