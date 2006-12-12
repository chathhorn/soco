class FriendsController < ApplicationController

  def index
    redirect_to :action => 'friends_list'
  end

  def friends_list
#    if params[:id] != nil
#      @friend_list = Friends_list.find(params[:id])
#    else
#      @friend_list = Friends_list.find(@session[:user])
#   
#    end
    @title = 'Friends Page of ' + @user.first_name + ' ' + @user.last_name
  end
end