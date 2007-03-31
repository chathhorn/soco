
class FacebookController < ApplicationController
  def index
      redirect_to controller[:profile].show
  end
  
  def start_session
      session[:facebook_session] = RBook::FacebookWebSession.new('db204644ba402b4d86ac2886372a96bf', '776bfd48e704d1e64f1dcaf24c867bc5')
      redirect_to session[:facebook_session].get_login_url    
  end
    
  def friends_get
    begin
      session[:facebook_session].init_with_token(params[:auth_token])
    rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = "An exception occurred while trying to authenticate with Facebook: #{e}"
      redirect_to :controller => 'profile', :action => 'show'
      return
    end
    
    begin
      #this is queued up, not taken immediately
      redirect_to :controller => 'profile', :action => 'show'
      
      @user = User.find session[:user]
      uid = session[:facebook_session].session_uid
      
      #do we want to add "AND is_app_user"?
      myResponse = session[:facebook_session].fql_query({:query => "SELECT first_name, last_name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=#{uid})"})
      
      (myResponse/"//user").each do |user|
        first_name = user.at("first_name").inner_html
        last_name = user.at("last_name").inner_html
        check_friends(first_name, last_name)
      end
    rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = "An exception occurred while trying to get friends from Facebook: #{e}"
    end
  end  

  def users_info
    begin
      #this is queued up, not taken immediately
      redirect_to :controller => 'profile', :action => 'show'

      my2ndResponse = session[:facebook_session].users_getInfo({:uids => @friends_uid, :fields => ['name']})
      puts my2ndResponse.to_html
      @friends_names = []
      my2ndResponse.search("//name").each do | test2 |
        my2ndstring = test2.innerHTML
        puts my2ndstring
        @friends_names << my2ndstring
        @friends << my2ndString
      end
    rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = "An exception occurred while trying to get friends userInfo from Facebook: #{e}"
    end
  end   
  
  private
  def check_friends(first_name, last_name)
    friends = User.find :all, :conditions => ["first_name = ? AND last_name = ?", first_name, last_name]
    friends.each do |friend| 
      if not @user.friends.exists? friend.id
        @user.friends.concat friend
        friend.friends.concat @user
      end
   end
  end
  
#  def users_info_old
#      myResponse = session[:facebook_session].users_getInfo({:uids => [1908269, 1914700], :fields => ['about_me', 'activities', 'birthday']})
#      puts myResponse.to_html
#      redirect_to :action => 'show'
#      rescue RBook::FacebookSession::RemoteException => e
#      flash[:error] = "An exception occurred while trying to authenticate with Facebook: #{e}"    
#  end  
   
#  def friends_get_not_working
#      myResponse = session[:facebook_session].friends_get({:uids => [@session_uid]})
#      puts myResponse.to_html
#      @friends_uids = []
#      @friends_names = []
#      @combined_uid = '['
#      myElementArray = myResponse.search("//uid");
#      index = 0
#      myElementArray.each do |test| 
#        mystring = test.innerHTML
#        puts mystring 
#        @friends_uids << mystring
#        @combined_uid += mystring
#        index += 1
#        if(index < myElementArray.length) 
#          @combined_uid += ", "
#        end
#      end
#      @combined_uid += ']'
#      puts 'friends_uids = ' + @combined_uid
#      if(index > 0)
#        redirect_to :action => 'users_info'
#      else
#        redirect_to :action => 'show'
#      end
#      rescue RBook::FacebookSession::RemoteException => e
#      flash[:error] = "An exception occurred while trying to get friends from Facebook: #{e}"    
#  end  
  
end
