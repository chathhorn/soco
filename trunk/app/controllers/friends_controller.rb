class FriendsController < ApplicationController

  def index
    redirect_to :action => 'friends_list'
  end

  def friends_list
    if params[:id] != nil
      @user = User.find(params[:id])
    else
      @user = User.find(@session[:user])
    end
    @title = 'Friends Page of ' + @user.first_name + ' ' + @user.last_name
  end
end