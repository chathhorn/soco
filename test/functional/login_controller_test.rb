require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end

class LoginControllerTest < Test::Unit::TestCase
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
    get :validate, "username"=>"nikhil", "password_hash"=>"sonie"
    assert_not_nil assigns["user"]
    assert_nil assigns["user"]
    assert assign.empty?
    assert flash.has_error?
  end
  
  #check for login success
  def test_login_success
    get :validate, "username"=>"james", "password_hash"=>"bond"
    assert_not_nit assigns["user"]
    assert_equal 1, assigns["user"].id
    assert flash.empty?   
  end    
  
  
end
