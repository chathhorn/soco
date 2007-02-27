require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end

class LoginControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = LoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #gets the index page successfully?
  def test_index
    get :index
    assert_response :success
  end
  
  #check for login failure
  def test_login_failure
    get :validate, :user=>"nikhil", :pass=>"sonie"
    assert_nil assigns["user"]
    assert_nil session[:user]
    assert_not_nil flash[:error]
  end
  
  #check for login success
  def test_login_success
    get :validate, :user=>"james", :pass=>"bond"
    assert_not_nil assigns["user"]
    assert_equal 1, assigns["user"].id
    assert_equal 1, session[:user]
    assert flash.empty?   
  end    
  
  
end
