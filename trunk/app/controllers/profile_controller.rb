class ProfileController < ApplicationController
  skip_filter :authenticate, :only => :register

  def index
    redirect_to :action => 'show'
  end

  def show
    if params[:id] != nil
      @user = User.find(params[:id])
    else
      @user = User.find(session[:user])
    end
    @friends = @user.friends
    @title = 'Profile for ' + @user.first_name + ' ' + @user.last_name
  end

  def register
    @title = 'Register'
    if (params[:user] != nil)
      @user = User.new(params[:user])
      if @user.save
        session[:user] = @user.id
        flash[:notice] = 'Your account is now created!'
        redirect_to :action => 'show'
      end
    else
      @user = User.new()
    end
    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end

  def edit
    @user = User.find(session[:user])
    if params[:user]
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your changes have been successfully saved.'
        redirect_to :action => 'show', :id => @user
        return
      end
    end

    @title = 'Change Profile'
    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end

  def destroy
    User.find(session[:user]).destroy
    redirect_to :controller => 'login'
  end
end
