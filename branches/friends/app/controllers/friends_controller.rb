class FriendsController < ApplicationController
  def index
    @title = ''
    @user = User.find(session[:user])
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find(:all, :order => 'year ASC, semester ASC')
  end


  def search
  
  end
  
  def list
    @user = User.find(session[:user])
    @friends = @user.friends.slice(1,5)
  end
  
  def browse
  
  end

  def add
    user = User.find session[:user]
 
  end
 
  def remove
    user = User.find session[:user]
    friend = User.find params[:id]
    user.friends.delete friend.id
    friend.friends.delete user.id
    redirect_to :controller => '/profile', :action => 'show'
  end
end
