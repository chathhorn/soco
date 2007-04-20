class FriendsController < ApplicationController
  def index
    @title = ''
    @user = User.find(session[:user])
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find :all
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
    @friends = @user.friends
  end
  
  def browse
    @user = User.find(session[:user])
    @friends = User.find :all
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
    user_id = session[:user]
    friend_id = params[:id].to_i
    
    #user = User.find session[:user]
    #friend = User.find params[:id]

    Relationship.delete_all ["(user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)", user_id, friend_id, friend_id, user_id]
    
    #WARN
    #broken in rails
    #user.friends.delete friend
    #friend.friends.delete user
    
    redirect_to :controller => 'profile', :action => 'show'
  end
end
