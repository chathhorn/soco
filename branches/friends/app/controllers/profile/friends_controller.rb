class Profile::FriendsController < ApplicationController

  def index
    @title = ''
    @user = User.find(session[:user])
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find(:all, :order => 'year ASC, semester ASC')
  end


  def search
  
  end
  
  def list
  
  end
  
  def browse
  
  end

  def add
  
 
  end
 
  def remove
    user = User.find session[:user]
    friend = User.find params[:id]
    user.friends.delete friend
    redirect_to :controller => 'profile', :action => 'show'
  end
   
end
