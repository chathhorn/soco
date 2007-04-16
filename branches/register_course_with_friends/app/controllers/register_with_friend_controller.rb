class RegisterWithFriendController < ApplicationController
  scaffold :register_with_friend   
  
  def index
    
    @user = User.find(session[:user])
    
    
  end
  
  def list  
    @buddies = FriendsUsers.find(:all,
                                 :joins=>"INNER JOIN register_with_friends on register_with_friends.friends_users_id = friends_users.id",
    :conditions=>{:user_id => session[:user]})                                                                                           
    #second case: to add the semester number too
  end
  
  def add
    # add a course to register together   
    
    # first case: add it into the log
    user = User.find(session[:user]).id
    friend = params[:friend]
    course_id = params[:course]
    
    
    x = FriendsUsers.find(:first,
                          :conditions => {:user_id => user,
      :friend_id => friend})
    y = FriendsUsers.find(:first,
                          :conditions => {:user_id => friend,
      :friend_id => user})
    

    if ((x!= nil) and (y != nil))
      
      user_side = RegisterWithFriend.new(:friends_users_id => x.id,
                                         :cis_courses_id => course_id).save      
      buddy_side = RegisterWithFriend.new(:friends_users_id => y.id, 
                                          :cis_courses_id => course_id).save   
      
      #check uniqueness                                          
      if (user_side and buddy_side)           
        flash[:notice] = "Operation Successful!"                             
      else
        flash[:error] = "You guys have already registered this course together!"      
      end
      
    else
      flash[:error] = "Cannot find you two as friend in database"                                                                                                                                                                                                      
    end                           
    
    
    redirect_to(:controller=>'long_term',:action => 'show', :id =>friend)
    
    
    # second case: if planned to register together make "register together 
    # link" inactive from 4 year schedule
    # third case: if not in the schedule add the course in the schedule
    # fourth case: if it is the current semester add a screen scraping so 
    # it can go too UofI integration 
  end
  
  def remove
    # remove a course that registers together
    # first case: basically remove that from the log and the database
     user = User.find(session[:user]).id
    friend = params[:friend]
    course_id = params[:course]
    
    
    x = FriendsUsers.find(:first,
                          :conditions => {:user_id => user,
      :friend_id => friend})
    y = FriendsUsers.find(:first,
                          :conditions => {:user_id => friend,
      :friend_id => user})
    

    if ((x!= nil) and (y != nil))
      
      user_side = RegisterWithFriend.find(:first,
                                           :conditions => {:friends_users_id => x.id,
                                                           :cis_courses_id => course_id}).destroy      
      buddy_side = RegisterWithFriend.find(:first,
                                          :conditions => 
                                          {:friends_users_id => y.id, 
                                          :cis_courses_id => course_id}).destroy   
      
      #check uniqueness                                          
      if (user_side and buddy_side)           
        flash[:notice] = "Operation Successful!"                             
      else
        flash[:error] = "Operation Failed!"      
      end
      
    else
      flash[:error] = "Cannot find you two as friend in database"                                                                                                                                                                                                      
    end                               
   redirect_to(:action => 'list')        
    # make the "register together" link active again 
  end
  
  
end
