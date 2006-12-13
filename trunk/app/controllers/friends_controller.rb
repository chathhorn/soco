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
    @user = session[:user]
    @title = 'Friends Page'
  end
end