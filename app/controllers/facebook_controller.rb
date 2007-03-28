
class FacebookController < ApplicationController
  def index
      redirect_to controller[:profile].show
  end
  
  def facesession
      session[:facebook_session] = RBook::FacebookWebSession.new('485ba0cb3fc98c3ab2d02e91cd605608', '6961a47b0e8022253dcb6925332af0ee')
      redirect_to session[:facebook_session].get_login_url    
  end
    
  def facefriends
    begin
      puts 'facebook auth_token now = ' + params[:auth_token]
      session[:facebook_session].init_with_token(params[:auth_token])
      redirect_to :action => 'friends_get'
    rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = "An exception occurred while trying to authenticate with Facebook: #{e}"
      redirect_to :controller => 'profile', :action => 'show'
    end
  end 
    
  def friends_get
    begin
      #this is queued up, not taken immediately
      redirect_to :controller => 'profile', :action => 'show'

      myResponse = session[:facebook_session].friends_get({:uids => [@session_uid]})
      puts myResponse.to_html
      @friends_uids = []
      @friends_names = []
      @friends_all = User.find :all, :order => 'last_name ASC, first_name ASC'
      myResponse.search("//uid").each do|test| 
        mystring = test.innerHTML
        puts mystring 
        @friends_uids << mystring
        my2ndResponse = session[:facebook_session].users_getInfo({:uids => [mystring], :fields => ['name']})
        puts my2ndResponse.to_html
          my2ndResponse.search("//name").each do | test2 |
            my2ndstring = test2.innerHTML
            puts my2ndstring
            
            @friends_names << my2ndstring
            ffirst_name = ''
            flast_name = ''
            index = 0
            my2ndstring.scan(/\w+/){ |word|
              if(index > 0)
                flast_name = word
              else
                ffirst_name = word
              end
              index += 1 
            }
            puts "first_name = " + ffirst_name
            puts "last_name = " + flast_name 
            check_friends(ffirst_name, flast_name)     
          end
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
      @friends_all.each do |aUser | 
        if(first_name == aUser.first_name and last_name == aUser.last_name)
            friend = User.find aUser.id
            user = User.find session[:user]
            puts "friend = " + friend.to_s
            bfound = 0
            user.friends.each do |eUser |
              if(eUser.id == aUser.id)
                bfound = 1
              end
            end
            if(bfound == 1)
              puts 'friend id already exists'
            else
              puts 'adding friend id'
              user.friends.concat friend
              friend.friends.concat user
            end
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
