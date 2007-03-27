require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'

# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = ProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = 1
  end

  def test_index
    get :index
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:user)
  end

  def test_register
    num_users = User.count

    post :register, :user => {  :username=>'nikhil', 
                                :password=>'sonie123',
                                :first_name=>'abcd',
                                :last_name=>'cdef', 
                                :email=>'nsonie2@uiuc.edu',
                                :start_year=>'2009',
                                :start_sem=>'FA', 
                                :birthday=>'1990-10-29', 
                                :college => College.find(:first),
                                :major => Major.find(:first)
                                }

    assert_response :redirect
    assert_redirected_to :action => 'show'

    assert_equal num_users + 1, User.count
  end

  def test_edit
    get :edit

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:user)
  end
  
  def test_edit_submit
    post:edit, :id=>1, :user => {:username=>'nikhil', 
                                :password=>'sonie123',
                                :first_name=>'abcd',
                                :last_name=>'cdef', 
                                :email=>'nsonie2@uiuc.edu',
                                :start_year=>'2009',
                                :start_sem=>'FA', 
                                :birthday=>'1990-10-29', 
                                :college => College.find(:first),
                                :major => Major.find(:first)
                                }    
  
    assert_response :redirect
    assert_redirected_to :controller=>'profile', :action=>'show'
    
    assert_not_nil assigns("user")
    
    assert User.exists?(:username=>'nikhil', :first_name=>"abcd", :last_name=>"cdef",:email=>'nsonie2@uiuc.edu')
     
  end

  def test_destroy
    assert_not_nil User.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'login'

    assert_raise(ActiveRecord::RecordNotFound) {
      User.find(1)
    }
  end
end
