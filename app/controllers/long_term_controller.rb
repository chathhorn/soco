class LongTermController < ApplicationController
  def index
    @user = User.find session[:user]
    @title = "Long Term Planner of " << @user.first_name << " " << @user.last_name
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find :all 
  end
  
  def show
    @user = User.find params[:id]
    if @user == nil
      redirect_to :action => 'index'
    end
    
    @title = "Long Term Planner of " << @user.first_name << " " << @user.last_name
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find :all
  end  
  
  def add_class
    user = User.find(session[:user])
    class_id = params[:course][:number]  
    class_id.upcase!
     (subject, white, number) = class_id.scan(/^([A-Z]*)(\s*)(\d*)$/)[0]           
    
    if subject.nil? 
      flash[:error] = "Invalid Course"
    else
      if number.blank? && white.empty?
        flash[:error] = "Invalid Course"
      else
        results = CisSubject.search_for_course(class_id)
        if results.size == 1
          course = CisCourse.find results[0].id
          user.course_bin.cis_courses.concat course
        else
          flash[:error] = "Invalid Course"
        end
      end
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
    render :nothing => true
  end
  
  
  def auto_complete_for_course_number
    @courses = CisSubject.search_for_course(params[:course][:number])
    render :partial => 'auto_complete_course'
  end
  
end
