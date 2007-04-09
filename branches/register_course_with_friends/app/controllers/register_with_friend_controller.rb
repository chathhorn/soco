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
    # second case: if planned to register together make "register together 
    # link" inactive from 4 year schedule
    # third case: if not in the schedule add the course in the schedule
    # fourth case: if it is the current semester add a screen scraping so 
    # it can go too UofI integration 
  end
  
  def remove
    # remove a course that registers together
    # first case: basically remove that from the log and the database
    # make the "register together" link active again 
  end
  

end
