require 'vendor/plugins/RBook/lib/facebook_web_session'

class ProfileController < ApplicationController
  def index
    redirect_to :action => 'show'
  end

  def show
    if params[:id] != nil
      @user = User.find(params[:id])
    else
      @user = User.find(session[:user])
    end
    @friends = @user.friends
    @title = 'Profile for ' + @user.first_name + ' ' + @user.last_name
  end

  def register
    @title = 'Register'
    if (params[:user] != nil)
      @user = User.new(params[:user])
      if @user.save
        session[:user] = @user.id
        flash[:notice] = 'Your account is now created!'
        redirect_to :action => 'show'
      end
    else
      @user = User.new()
    end
    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end

  def edit
    @title = 'Change Profile'
    @user = User.find(session[:user])
    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end

  def update
    @user = User.find(session[:user])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your changes have been successfully saved.'
      redirect_to :action => 'show', :id => @user
    else
      redirect_to :action => 'edit'
    end
    @colleges = College.find(:all)
  end
  
  def facesession
      session[:facebook_session] = RBook::FacebookWebSession.new('485ba0cb3fc98c3ab2d02e91cd605608', '6961a47b0e8022253dcb6925332af0ee')
      redirect_to session[:facebook_session].get_login_url    
  end
    
  def facefriends
      puts 'facebook auth_token now = ' + params[:auth_token]
      session[:facebook_session].init_with_token(params[:auth_token])
      redirect_to :action => 'friendsGet'
      rescue RBook::FacebookSession::RemoteException => e
        flash[:error] = 'An exception occurred while trying to authenticate with Facebook: #{e}'
  end 
    
  def friendsGet
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
#            friend.find(friend[:last_name]) if @user.nil? && session[:id]
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
            checkFriends(ffirst_name, flast_name)     
#            friend.create(:first_name => ffirst_name, :last_name => flast_name)
          end
      end
      redirect_to :action => 'show'
      rescue RBook::FacebookSession::RemoteException => e
        flash[:error] = 'An exception occurred while trying to get friends from Facebook: #{e}'
  end  

  def usersInfo
      my2ndResponse = session[:facebook_session].users_getInfo({:uids => @friends_uid, :fields => ['name']})
      puts my2ndResponse.to_html
      @friends_names = []
      my2ndResponse.search("//name").each do | test2 |
        my2ndstring = test2.innerHTML
        puts my2ndstring
        @friends_names << my2ndstring
        @friends << my2ndString
      end
      redirect_to :action => 'show'
      rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = 'An exception occurred while trying to get friends names from Facebook: #{e}'    
  end   
  
  def checkFriends(first_name, last_name)
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
  
  def usersInfoOld
      myResponse = session[:facebook_session].users_getInfo({:uids => [1908269, 1914700], :fields => ['about_me', 'activities', 'birthday']})
      puts myResponse.to_html
      redirect_to :action => 'show'
      rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = 'An exception occurred while trying to authenticate with Facebook: #{e}'    
  end  
   
  def friendsGetNotWorking
      myResponse = session[:facebook_session].friends_get({:uids => [@session_uid]})
      puts myResponse.to_html
      @friends_uids = []
      @friends_names = []
      @combined_uid = '['
      myElementArray = myResponse.search("//uid");
      index = 0
      myElementArray.each do |test| 
        mystring = test.innerHTML
        puts mystring 
        @friends_uids << mystring
        @combined_uid += mystring
        index += 1
        if(index < myElementArray.length) 
          @combined_uid += ", "
        end
      end
      @combined_uid += ']'
      puts 'friends_uids = ' + @combined_uid
      if(index > 0)
        redirect_to :action => 'usersInfo'
      else
        redirect_to :action => 'show'
      end
      rescue RBook::FacebookSession::RemoteException => e
      flash[:error] = 'An exception occurred while trying to get friends from Facebook: #{e}'    
  end  
  

  # SECTION: Private Methods

  def destroy
    User.find(session[:user]).destroy
    redirect_to :controller => 'login'
  end

end
