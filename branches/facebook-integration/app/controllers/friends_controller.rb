class FriendsController < ApplicationController
  def index
    @title = ''
    @user = User.find(session[:user])
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find(:all, :order => 'year ASC, semester ASC')
  end


  def search
    @user = User.find(session[:user])
    if (params[:q])
      @friends = User.search(params[:q])
    else
      @friends = []
    end
    render :action => 'list'
  end
  
  def list
    @user = User.find(session[:user])
    @friends = @user.friends.slice(0,10)
  end
  
  def browse
    @user = User.find(session[:user])
    @friends = User.find :all, :order => 'last_name ASC, first_name ASC'
    render :action => 'list'
  end

  def add
    user = User.find session[:user]
    friend = User.find params[:id]
    
    if user != friend
      if !user.friends.exists?(params[:id])
        user.friends.concat friend
        friend.friends.concat user
      else
        flash[:error] = 'Sorry, you cannot add the same friend more than once.'
      end
      redirect_to :controller => 'profile', :action => 'show'
    else
      flash[:error] = 'Sorry, you cannot be your own friend.'
      redirect_to :back
    end
    
  end
 
  def remove
    user = User.find session[:user]
    friend = User.find params[:id]
    
    user.friends.delete friend
    friend.friends.delete user
    
    redirect_to :controller => 'profile', :action => 'show'
  end
end
