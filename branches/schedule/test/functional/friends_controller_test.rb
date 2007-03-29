require File.dirname(__FILE__) + '/../test_helper'
require 'friends_controller'

# Re-raise errors caught by the controller.
class FriendsController; def rescue_action(e) raise e end; end

class FriendsControllerTest < Test::Unit::TestCase

  fixtures :users, :cis_courses, :course_bins, :cis_subjects
  
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
  
def test_search
  get :search, :q=>"Tanmay"
  assert_response :success
end

def test_browse
  get :browse
  assert_response :success
end

def test_add
  get :browse
  user = User.find(session[:user]) 
  count = user.friends.count

  post :add, :id=>4
  assert_response :redirect
  assert_redirected_to :controller => 'profile',:action=>'show'
  assert_equal count+1, user.friends.count
 
end

def test_remove
  get :browse
  user = User.find(session[:user]) 
  count = user.friends.count
  
  post :add, :id=>4
  assert_response :redirect
  assert_redirected_to :controller => 'profile',:action=>'show'
  assert_equal count+1, user.friends.count
  
  
  post :remove, :id=>4
  assert_response :redirect
  assert_redirected_to :controller => 'profile',:action=>'show'
  assert_equal count, user.friends.count
end  
  
#system testing
def test_friends_system
#check for search
  get :search, :q=>"Tanmay"
  assert_response :success

#check for browse
  get :browse
  assert_response :success

#check for adding friend
  user = User.find(session[:user]) 
  count = user.friends.count

#adds a friend with id=2 which is defined in the fixture given above
  post :add, :id=>4
  assert_response :redirect
  assert_redirected_to :controller => 'profile',:action=>'show'
  assert_equal count+1, user.friends.count

 #check for removing friend  
  post :remove, :id=>4
  assert_response :redirect
  assert_redirected_to :controller => 'profile',:action=>'show'
  assert_equal count, user.friends.count
end
end
