require File.dirname(__FILE__) + '/../test_helper'
require 'course_reviews_controller'

# Re-raise errors caught by the controller.
class CourseReviewsController; def rescue_action(e) raise e end; end

class CourseReviewsControllerTest < Test::Unit::TestCase
  def setup
    @controller = CourseReviewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.


def test_post
  get :post
  assert_response :redirect
end


end
