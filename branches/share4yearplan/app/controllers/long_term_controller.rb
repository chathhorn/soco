class LongTermController < ApplicationController
  def index
    @user = User.find session[:user]          
    @title = 'Long Term Planner of '.concat(@user.username)    
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find(:all, :order => 'year ASC, semester ASC')
  end
  
  def show
    @user = User.find params[:id]          
    @title = 'Long Term Planner of '.concat(@user.username)    
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find(:all, :order => 'year ASC, semester ASC')        
  end  
  
  def add_class
    user = User.find(session[:user])
    class_id = params[:course][:number]
    
    results = CisSubject.search_for_course(class_id)
    
    if results.size == 1
      course = CisCourse.find results[0].id
      user.course_bin.cis_courses.concat course
    else
      flash[:error] = "Invalid Course"
    end
    
    redirect_to(:action => 'index')
  end
  
  def update_semester
    @user = User.find(session[:user])
    course = CisCourse.find(params[:id].split('_')[2].to_i)
    new_semester_id = params[:new_semester].to_i
    old_semester_id = params[:id].split('_')[1].to_i
    
    if old_semester_id == -1
      @user.course_bin.cis_courses.delete(course)
    else
      course.semesters.delete(Semester.find(old_semester_id))
    end
    if new_semester_id == -1
      @user.course_bin.cis_courses.concat(course)
    else
      course.semesters.concat(Semester.find(new_semester_id))
    end
    
    render :partial => 'course', :object => course, :locals => {:semester => new_semester_id, :effect => true}
  end
  
  def remove
    @user = User.find(session[:user])
    course = CisCourse.find(params[:id].split('_')[2].to_i)
    old_semester_id = params[:id].split('_')[1].to_i
    
    if old_semester_id == -1
      @user.course_bin.cis_courses.delete(course)
    else
      course.semesters.delete(Semester.find(old_semester_id))
    end
  end
  
  
  def auto_complete_for_course_number
    @courses = CisSubject.search_for_course(params[:course][:number])
    render :partial => 'auto_complete_course'
  end
end
