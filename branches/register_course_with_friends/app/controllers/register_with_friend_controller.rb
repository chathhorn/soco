class RegisterWithFriendController < ApplicationController

  def index
    @title = 'Register Planning'
    @user = User.find(session[:user])
  end
  
  def list
    @register_with_friend = register_with_friend.find_all;            
  end
    
end
