require File.dirname(__FILE__) + '/../test_helper'
require 'long_term_controller'

# Re-raise errors caught by the controller.
class LongTermController; def rescue_action(e) raise e end; end

class LongTermControllerTest < Test::Unit::TestCase

  fixtures :users, :cis_courses, :course_bins, :cis_subjects

  
  def setup
    @controller = LongTermController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = 1
  end

 def test_index
   get :index
   assert_response :success
 end
 
 def test_show  
  get :show, :id => @request.session[:user]
  assert_response :success
  assert_template 'show'
  assert_not_nil assigns(:user)  
 end
  
 def test_add_class
   user = User.find(@request.session[:user]) 
   count = user.course_bin.cis_courses.count   
   
   post :add_class,  :course=>{:number=>"CS225"}
            
   assert_response :redirect
   assert_redirected_to :action => 'index'  
   assert flash.empty?       
        
   assert_equal count+1, user.course_bin.cis_courses.count
   
 end
 
 def test_remove_class_from_course_bin
 
  user = User.find(@request.session[:user])
  
  post :add_class, :course=>{:number=>"CS225"}
  post :add_class, :course=>{:number=>"CS473"}
  
  assert_equal 2, user.course_bin.cis_courses.count
  
  post :remove, :id=>'coursediv_-1_3'
  assert_response :success
  assert_equal 1, user.course_bin.cis_courses.count  

 end
 
 def test_update_semester
  user = User.find(@request.session[:user])
  
  post :add_class, :course=>{:number=>"CS225"}
  post :add_class, :course=>{:number=>"CS473"}
  
  assert_equal 2, user.course_bin.cis_courses.count
  
  post :update_semester, {:id=>'coursediv_-1_3', :new_semester=>1}
  assert_response :success
  
  post :update_semester, {:id=>'coursediv_-1_1', :new_semester=>1}
  assert_response :success
  
  assert_equal 0, user.course_bin.cis_courses.count
  
  semester = Semester.find(1)
  assert_equal 2, semester.cis_courses.count
  
  post :remove, :id=>'coursediv_1_1'
  
  assert_equal 1, semester.cis_courses.count

 end
 
# 
# /* Added by Nikhil and Tanmay... this test does not work ... 
# we got confused how to test it 
# */
# 
# def test_update_semester
#
#  get:index
#  
#  user = User.find(session[:user]) 
#  count = user.course_bin.cis_courses.count   
#   
#  post :add_class,  :course=>{:number=>"CS225"}
#  
#  get :update_semester, :id=>-1, :new_semester=>2007  
#  assert_respose :success
#  
#               
#  assert_equal count+1, user.course_bin.cis_courses.count   
#  
#end
#
#  
 
# def test_remove_course
#    get :index
#   
#   user = User.find(session[:user]) 
#   count = user.course_bin.cis_courses.count   
#   
#   post :add_class,  :course=>{:number=>"CS225"}
#            
#   assert_equal count+1, user.course_bin.cis_courses.
#
#    class_id = params[:course][:number]
#    assert_equal 10000, class_id
#    
#    results = CisSubject.search_for_course(class_id)
#    course = CisCourse.find results[0].id
#   post :remove, course.id
#   
#   assert_response :success
#   
#   
#   
# 
# end

 
 
 def test_course_name_gt_6_chars
    post :add_class, :course=>{:number=>"ABCDEFG225"}
    assert_response :redirect
    assert_redirected_to :action => 'index'   
    assert_equal false, flash.empty?
    assert_equal "Invalid Course" ,flash[:error]            
 end

 #add the course if it exists in DB
 def test_course_name_lt_6_chars
     user = User.find(@request.session[:user]) 
     count = user.course_bin.cis_courses.count   
 
    post :add_class, :course=>{:number=>"PSYCH100"}

    assert_response :redirect
    assert_redirected_to :action => 'index'  
    assert flash.empty?       
        
    assert_equal count+1, user.course_bin.cis_courses.count            
 end
 
 def test_course_number_gt_3_digits
    post :add_class, :course=>{:number=>"CS2255"}
    assert_response :redirect
    assert_redirected_to :action => 'index'      
    assert_equal "Invalid Course" ,flash[:error]            
 end
    
 #adds the first course in the auto complete      
 def test_course_number_lt_3_digits
     user = User.find(@request.session[:user]) 
     count = user.course_bin.cis_courses.count   
   
 
    post :add_class, :course=>{:number=>"CS22"}
    
    assert_response :redirect
    assert_redirected_to :action => 'index'  
    assert flash.empty?       
        
    assert_equal count+1, user.course_bin.cis_courses.count        
            
 end    
 
 def test_nil_case
    post :add_class, :course=>{:number=>""}
    assert_response :redirect
    assert_redirected_to :action => 'index'      
    assert_equal "Invalid Course" ,flash[:error]            
 end
 
     
end
