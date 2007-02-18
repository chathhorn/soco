require File.dirname(__FILE__) + '/../../test_helper'
require 'profile/friends_controller'

# Re-raise errors caught by the controller.
class Profile::FriendsController; def rescue_action(e) raise e end; end

class Profile::FriendsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Profile::FriendsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
