require File.dirname(__FILE__) + '/../test_helper'
require 'semester_controller'

# Re-raise errors caught by the controller.
class SemesterController; def rescue_action(e) raise e end; end

class SemesterControllerTest < Test::Unit::TestCase
  fixtures :semesters, :users, :cis_courses, :cis_sections, 
    :course_plans, :cis_semesters
  
  def setup
    @controller = SemesterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = "1"
  end

  def test_show
    get :show, :id => "1"
    assert_response :success
  end
  
  def test_generate_prev
    @request.session[:marker] = 6
    get :generate_prev, {:id => "1"}
    assert_response :success
    assert !@request.session[:solution].nil?
    assert @request.session[:marker] == 0

    get :generate_prev, {:id => "1"}
    assert_response :success
    assert @request.session[:marker] == 0
  end
  
  def test_generate_next
    @request.session[:marker] = 0
    get :generate_next, {:id => "1"}
    assert_response :success
    assert !@request.session[:solution].nil?
    @request.session[:marker] = @request.session[:solution].length - 7
    get :generate_next, {:id => "1"}
    assert_response :success
    assert @request.session[:marker] == 0    
  end
  
  def test_show_previews
    get :show_previews, {:id => "1"}
    assert_response :success
    assert !session[:solution].nil?
    assert session[:generator_error] == 'No possible schedules.'
  end

  def test_toggle_section
    plan = User.find(1).semesters.find("1").course_plan
    
    get :toggle_section, {:id => "1", :section => "1"}
    assert_response :success
    assert(plan.cis_sections.exists?("1"))
    
    get :toggle_section, {:id => "1", :section => "1"}
    assert_response :success
    assert(!plan.cis_sections.exists?("1"))
  end

end
