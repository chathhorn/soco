class ProfileController < ApplicationController
  skip_filter :authenticate, :only => :register

  def index
    redirect_to :action => 'show'
  end

  #show a user's profile
  def show
    if params[:id] != nil
      @user = User.find(params[:id])
    else
      @user = User.find session[:user]
    end
    @friends = @user.friends
  end

  #register as a new user
  def register
    if (params[:user] != nil)
      @user = User.new(params[:user])
      if @user.save
        session[:user] = @user.id
        session[:username] = @user.username
        flash[:notice] = 'Your account is now created!'
        redirect_to :action => 'show'
        return
      end
    else
      @user = User.new()
    end
    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end

  #edit an existing user's profile
  def edit
    @user = User.find session[:user]
    if params[:user]
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your changes have been successfully saved.'
        redirect_to :action => 'show', :id => @user
        return
      end
    end

    @colleges = College.find(:all, :order => 'name ASC')
    @majors = Major.find(:all, :order => 'name ASC')
  end
  
  
    #edit an existing user's profile
  def messages
       # flash[:notice] = 'DELETEME'
        
    render :layout => 'reviews'
       

  end
  
  
  def messagespost
    if (params[:messages] != nil)
      @msg = Messages.new(params[:messages])
      if @msg.save

@notice = "<b>Message for " + params[:messages][:course] + " posted</b><script>parent.location='/profile/messages/showmessages?courseID=" + params[:messages][:course] + "'</script>"
        flash[:notice] = @notice
    render :layout => 'reviews'
    #        redirect_to :action => 'messages_posted'

        return
      end
    else
      msg = Messages.new()
      
        flash[:notice] = "Message failed. <script>parent.location='/profile/messages/showmessages?courseID=" + params[:messages][:course] + "'</script>"
    render :layout => 'reviews'
#        redirect_to :action => 'messages_posted'
        return
    end

      @msg = Messages.new()
      @msg.save
        flash[:notice] = "Message failed2. <script>parent.location='/profile/messages/showmessages?courseID=" + params[:messages][:course] + "'</script>"
    render :layout => 'reviews'
#        redirect_to :action => 'messages_posted'
        return    
  end
  
    #search for course by string
  def showmessages


    @user = User.find session[:user]
#    @messages = Messages.find :all, :order => 'id ASC'
    render :action => 'showmessageslist'
  
  end
  
  def showmessageslist
    @user = User.find session[:user]
 #   @messages = @user.messages
  end

  #remove the logged in user from the system
  def destroy
    current_user = User.find session[:user]
    current_user.destroy
    redirect_to :controller => 'login', :action => 'logout'
  end
end
