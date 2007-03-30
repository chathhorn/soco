class LoginController < ApplicationController
layout "blank"

  
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
      redirect_to :controller => 'profile'
    else
      flash[:error] = "Invalid user name or password."
      redirect_to :action => 'welcome'
    end
  end
  
  def logout
    reset_session
    flash[:alert] = "Logged out" 
    redirect_to :action => "welcome" 
#    redirect_to "login.html"
  end
  

  
  
  def register
    @title = 'Register'
    if (params[:user] != nil)
      @user = User.new(params[:user])
      if @user.save
        session[:user] = @user.id
        flash[:notice] = 'Your account is now created!'
        redirect_to :action => 'welcome'
#        @@duh = "<script>parent.location='/profile/show';</script>"
#@duh
      end
    else
      @user = User.new()
    end
    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end  
  
  
  
  
end
