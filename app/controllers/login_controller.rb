class LoginController < ApplicationController
  def index
    @title = "Login"
    #see login.rhtml
  end
  def validate
    @user = User.validate_user(params[:user], params[:pass])
    if @user != nil
      @session[:user] = @user
      redirect_to(:controller => "profile", :action => "list")
    else
      render :action => "index"
      flash[:error] = "Invalid user name or password."
    end
  end
end
