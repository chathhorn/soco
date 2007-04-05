require File.dirname(__FILE__) + '/../test_helper'
require 'course_share_controller'

# Re-raise errors caught by the controller.
class CourseShareController; def rescue_action(e) raise e end; end

class CourseShareControllerTest < Test::Unit::TestCase
  def setup
    @controller = CourseShareController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
