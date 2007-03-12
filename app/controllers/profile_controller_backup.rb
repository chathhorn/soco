

class ProfileController < ApplicationController
require "digest/md5"
require "net/https"
require "cgi"
require "hpricot"
API_SERVER_BASE_URL      = "api.facebook.com"
LOGIN_SERVER_BASE_URL    = "www.facebook.com"
API_SERVER_PATH          = "/restserver.php"
LOGIN_SERVER_PATH        = "/login.php"

  attr_reader :session_uid, :session_key, :session_secret
  def index
    redirect_to :action => 'show'
  end

  def initialize(api_key, api_secret, suppress_exceptions = false)
    
    # required parameters
    @api_key = api_key
    @api_secret = api_secret
    
    # calculated parameters
    @api_server_base_url = API_SERVER_BASE_URL
    @api_server_path = API_SERVER_PATH
        
    # optional parameters
    @suppress_exceptions = suppress_exceptions
    
    # initialize internal state
    @last_call_was_successful = true
    @last_error = nil
    
    # virtual members (subclasses will set these)
    @session_uid = nil
    @session_key = nil
    
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
 
 
 
 
  
  def init_with_token(auth_token)
    result = call_method("auth.getSession", {:auth_token => auth_token})
    if result != nil
      @session_uid = result.at("uid").inner_html
      @session_key = result.at("session_key").inner_html
    end
  end
  # Function: post_request
  #   Does a post to the given server/path, using the params as formdata
  #
  # Parameters:
  #   api_server_base_url         - i.e. "api.facebook.com"
  #   api_server_path             - i.e. "/restserver.php"
  #   method                      - i.e. "facebook.users.getInfo"
  #   params                      - hash of key/value pairs that get sent as form data to the server
  #   use_ssl                     - set to true if you want to use SSL for this request
  def post_request(api_server_base_url, api_server_path, method, params, use_ssl)
    
    # get a server handle
    port = (use_ssl == true) ? 443 : 80
    http_server = Net::HTTP.new(@api_server_base_url, port)
    http_server.use_ssl = use_ssl
    
    # build a request
    http_request = Net::HTTP::Post.new(@api_server_path)
    http_request.form_data = params
    response = http_server.start{|http| http.request(http_request)}.body
    
    # return the text of the body
    return response
    
  end
  # Function: param_signature
  #   Generates a param_signature for a call to the API, per the spec on Facebook
  #   see: <http://developers.facebook.com/documentation.php?v=1.0&doc=auth>
  def param_signature(params)
    
    args = []
    params.each do |k,v|
      args << "#{k}=#{v}"
    end
    sorted_array = args.sort
    request_str = sorted_array.join("")
    param_signature = Digest::MD5.hexdigest("#{request_str}#{get_secret(params)}") # uses Template method get_secret
    return param_signature
    
  end

  # Function: get_secret
  def get_secret(params)
    @api_secret="6961a47b0e8022253dcb6925332af0ee"
    return @api_secret
    
  end
  
  def facefriends
    if params[:auth_token] != nil
      @auth_token = params[:auth_token]    
      puts "facefriends token returned = " + @auth_token
      initialize("485ba0cb3fc98c3ab2d02e91cd605608", "6961a47b0e8022253dcb6925332af0ee", true)
      @session_key = init_with_token(@auth_token)
      puts "session key = " + @session_key
    end
  end

  def call_method(method, params, use_ssl=false)
    
    # set up params hash
    params[:method] = "facebook.#{method}"
    params[:api_key] = @api_key
    params[:v] = "1.0"
    
    if (method != "auth.getSession" and method != "auth.createToken")
      params[:session_key] = @session_key
      params[:call_id] = Time.now.to_f.to_s
    end
    
    # convert arrays to comma-separated lists
    params.each{|k,v| params[k] = v.join(",") if v.is_a?(Array)}
    
    # set up the param_signature value in the params
    params[:sig] = param_signature(params)
    
    # prepare internal state
    @last_call_was_successful = true
    @last_error = nil
    
    # do the request
    xmlstring = post_request(@api_server_base_url, @api_server_path, method, params, use_ssl)
    xml = Hpricot(xmlstring)

    # error checking    
    if xml.at("error_response")
      @last_call_was_successful = false
      code = xml.at("error_code").inner_html
      msg = xml.at("error_msg").inner_html
      @last_error = "ERROR #{code}: #{msg}"
      raise RemoteException, @last_error unless @suppress_exceptions == true
      return nil
    end
    
    return xml
  end
  
  # SECTION: Private Methods

  def destroy
    User.find(session[:user]).destroy
    redirect_to :controller => 'login'
  end
end
