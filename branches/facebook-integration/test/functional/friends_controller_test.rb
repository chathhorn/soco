require File.dirname(__FILE__) + '/../test_helper'
require 'friends_controller'

# Re-raise errors caught by the controller.
class FriendsController; def rescue_action(e) raise e end; end

class FriendsControllerTest < Test::Unit::TestCase
  fixtures :users, :friends_users

  def setup
    @controller = FriendsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.session[:user] = 1
  end
  
  def test_add_same_user
    initial_count_james = users(:james).friends.count
    initial_count_john = users(:john).friends.count
  
    get :add, :id => 2
    
    assert_equal users(:james).friends.count, initial_count_james + 1
    assert_equal users(:john).friends.count, initial_count_john + 1

    get :add, :id => 2
    
    assert_equal users(:james).friends.count, initial_count_james + 1
    assert_equal users(:john).friends.count, initial_count_john + 1
    
  end
  
  
  def test_search_email_and_name
    get :search, :q => "jdoe john"
    
    assert_not_nil assigns["friends"]
    
    assert_equal 1, assigns["friends"].size
    
    assert_response :success
    assert_template 'list'
  end
end
