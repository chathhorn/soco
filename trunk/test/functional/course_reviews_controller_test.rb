require File.dirname(__FILE__) + '/../test_helper'
require 'course_reviews_controller'

# Re-raise errors caught by the controller.
class CourseReviewsController; def rescue_action(e) raise e end; end

class CourseReviewsControllerTest < Test::Unit::TestCase
  def setup
    @controller = CourseReviewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = 1
    @request.env["HTTP_REFERER"] = "/coursereviews/list/1"    
  end
  
  
  def test_post
    get :post, {'id'=>"1"}
    assert_response :redirect  
  end
  
  def test_post_nil
    get :post
    assert_response :redirect  
  end
  
  def test_list
    get :list, {'id'=>"1"}
    assert_response :success
  end
  
  def test_list_nil
    # test nil case
    get :list
    assert_response :success    
  end
  
  
  
end
