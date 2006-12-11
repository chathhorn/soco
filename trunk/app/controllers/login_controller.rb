class LoginController < ApplicationController
  def index
  end
  def validate
    @user = User.authenticate(params[:user], params[:pass])
    if @user != nil
      @session[:user] = @user.id
      redirect_to :controller => 'profile'
    else

      flash[:error] = "Invalid user name or password."
      render :action => 'index'
    end
  end  
end
