class LongTermController < ApplicationController
  def index
    @user = User.find(@session[:user])
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters
  end
  
  def update_semester
    @user = User.find(@session[:user])
    course = CisCourse.find(params[:id].split('_')[2].to_i)
    new_semester_id = params[:new_semester].to_i
    old_semester_id = params[:id].split('_')[1].to_i
        
    if old_semester_id == -1
      @user.course_bin.remove_cis_courses(course)
    else
      course.remove_semesters(Semester.find(old_semester_id))
    end
    if new_semester_id == -1
      @user.course_bin.add_cis_courses(course)
    else
      course.add_semesters(Semester.find(new_semester_id))
    end
    
    render :partial => 'course', :object => course, :locals => {:semester => new_semester_id}
  end
end
