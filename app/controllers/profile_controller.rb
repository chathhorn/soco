class ProfileController < ApplicationController
  def index
    redirect_to :action => 'show'
  end

  def show
    if params[:id] != nil
      @user = User.find(params[:id])
    else
      @user = User.find(@session[:user])
    end
    @friends = @user.friends
    @title = 'Profile for ' + @user.first_name + ' ' + @user.last_name
  end

  def register
    @title = 'Register'
    if (params[:user] != nil)
      @user = User.new(params[:user])
      if @user.save
        @session[:user] = @user.id
        flash[:notice] = 'Your account is now created!'
        redirect_to :action => 'show'
      end
    else
      @user = User.new()
    end
    @colleges = College.find(:all)
  end

  def edit
    @title = 'Change Profile'
    @user = User.find(@session[:user])
    @colleges = College.find(:all)
  end

  def update
    @user = User.find(@session[:user])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your changes have been successfully saved.'
      redirect_to :action => 'show', :id => @user
    else
      redirect_to :action => 'edit'
    end
    @colleges = College.find(:all)
  end

  def destroy
    User.find(@session[:user]).destroy
    redirect_to :controller => 'login'
  end
end
