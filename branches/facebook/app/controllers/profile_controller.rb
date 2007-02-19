require 'vendor/plugins/RBook/lib/facebook_web_session'

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
    @user = User.find(session[:user])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your changes have been successfully saved.'
      redirect_to :action => 'show', :id => @user
    else
      redirect_to :action => 'edit'
    end
    @colleges = College.find(:all)
  end
  
  def facesession
      session[:facebook_session] = RBook::FacebookWebSession.new('485ba0cb3fc98c3ab2d02e91cd605608', '6961a47b0e8022253dcb6925332af0ee')
      redirect_to session[:facebook_session].get_login_url    
  end
    
  def facefriends
      puts 'facebook auth_token now = ' + params[:auth_token]
      session[:facebook_session].init_with_token(params[:auth_token])
      redirect_to :action => 'friendsGet'
      rescue RBook::FacebookSession::RemoteException => e
        flash[:error] = 'An exception occurred while trying to authenticate with Facebook: #{e}'
  end 
    
  def friendsGet
      myResponse = session[:facebook_session].friends_get({:uids => [@session_uid]})
      puts myResponse.to_html
      redirect_to :action => 'show'
  end   
  def usersInfo
      myResponse = session[:facebook_session].users_getInfo({:uids => [1908269, 1914700], :fields => ['about_me', 'activities', 'birthday']})
      puts myResponse.to_html
      redirect_to :action => 'show'
      rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = 'An exception occurred while trying to authenticate with Facebook: #{e}'    
  end   

  # SECTION: Private Methods

  def destroy
    User.find(session[:user]).destroy
    redirect_to :controller => 'login'
  end

end
