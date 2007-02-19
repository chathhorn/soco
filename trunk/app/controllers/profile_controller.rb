class ProfileController < ApplicationController
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
      if(params[:passwordconfirm] != params[:user][:password])
        flash[:error] = 'Your passwords must match!'
        redirect_to :action => 'register'
        return
      end
      if(params[:passwordconfirm].length < 6)
        flash[:error] = 'Your password must be at least 6 characters long!'
        redirect_to :action => 'register'     
        return
      end
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
    @title = 'Change Profile'
    @user = User.find(session[:user])
    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end

  def update
    if(params[:passwordconfirm].length < 6 and params[:passwordconfirm].length > 0)
      flash[:error] = 'Your new password must be at least 6 characters long!'
      redirect_to :action => 'edit'     
      return
    end
    @user = User.find(session[:user])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your changes have been successfully saved.'
      redirect_to :action => 'show', :id => @user
    else
      redirect_to :action => 'edit'
    end
    @colleges = College.find(:all)
  end

  def destroy
    User.find(session[:user]).destroy
    redirect_to :controller => 'login'
  end
end
