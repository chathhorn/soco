class LongTermController < ApplicationController
  def index
    @user = User.find(@session[:user])
    @course_bin_courses = @user.course_bin.cis_courses
    @semesters = @user.semesters.find(:all, :order => 'year ASC, semester ASC')
  end
  
  def add_class
    @user = User.find(@session[:user])
    class_id = params[:course][:number]
    if class_id.include? '-'
      subject = class_id.split('-')[0]
      number = class_id.split('-')[1]  
    else
      subject = class_id[0,class_id.length-3]
      number = class_id[-3,3]
    end
    
    subject_id = CisSubject.find_by_code(subject).id
    
    course = CisCourse.find_by_cis_subject_id_and_number(subject_id, number)
    
    @user.course_bin.add_cis_courses(course)
    
    redirect_to(:action => 'index')
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
    
    render :partial => 'course', :object => course, :locals => {:semester => new_semester_id, :effect => true}
  end
    
  def remove
    @user = User.find(@session[:user])
    course = CisCourse.find(params[:id].split('_')[2].to_i)
    old_semester_id = params[:id].split('_')[1].to_i
        
    if old_semester_id == -1
      @user.course_bin.remove_cis_courses(course)
    else
      course.remove_semesters(Semester.find(old_semester_id))
    end
  end
  
  
  def auto_complete_for_course_number
    @courses = Array.new
    
    value = params[:course][:number]
    if value.include? '-'
      subject = value.split('-')[0]
      number = value.split('-')[1]
      wildcard = ''
    else
      subject = value
      number = ''
      wildcard = '%'
    end

    subjects = CisSubject.find(:all, :conditions => [ 'LOWER(code) LIKE ?',
      subject.downcase + wildcard ], 
      :order => 'code ASC')
    for subject in subjects
      for course in subject.cis_courses.find(:all, 
        :conditions => [ 'LPAD(number,3,\'0\') LIKE ?', number.to_s + '%' ], 
        :order => 'LPAD(number,3,\'0\') ASC',
        :limit => 8)
        
        if course.number < 10
          pad = '00'
        elsif course.number < 100
            pad = '0'
        else
          pad = ''
        end
        
        @courses << subject.code + '-' + pad + course.number.to_s
        
        if @courses.length > 8
          break
        end
      end
      if @courses.length > 8
        break
      end
    end
    
    render :partial => 'auto_complete_course'
  end
end
