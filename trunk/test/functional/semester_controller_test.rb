require File.dirname(__FILE__) + '/../test_helper'
require 'semester_controller'

# Re-raise errors caught by the controller.
class SemesterController; def rescue_action(e) raise e end; end

class SemesterControllerTest < Test::Unit::TestCase
  fixtures :cis_sections, :cis_courses_semesters, :cis_courses, :semesters, :users

  def setup
    @controller = SemesterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = 1

  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_generate_next
    get :generate_next, {'id' => "1"}
    assert_response :success
  end
  
  def test_generate_prev
    get :generate_prev, {'id' => "1"}
    assert_response :success
  end
  
  #def test_toggle_section
  #  get :toggle_section, {'id'=> "1", 'section'=>"1"}
  #  assert_response :success
  end
  
  def test_show
    get :show, {'id'=> "1"}
    assert_response :success
  end
  
  def test_show_previews
    get :show_previews, {'id'=> "1"}
    assert_response :success
  end
  
end
