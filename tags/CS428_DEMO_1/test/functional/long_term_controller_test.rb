require File.dirname(__FILE__) + '/../test_helper'
require 'long_term_controller'

# Re-raise errors caught by the controller.
class LongTermController; def rescue_action(e) raise e end; end

class LongTermControllerTest < Test::Unit::TestCase
  def setup
    @controller = LongTermController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
