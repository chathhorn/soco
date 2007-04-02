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
  
  def remove
    @user = User.find(session[:user])
    course = CisCourse.find(params[:course_id].to_i)
    old_semester_id = params[:semester_id].to_i
    
    if old_semester_id == -1
      @user.course_bin.cis_courses.delete(course)
    else
      course.semesters.delete(Semester.find(old_semester_id))
    end
    redirect_to :action => "index"
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
      # remove sections from old semester
      sections_from_course(course, Semester.find(old_semester_id)) and @user.semesters.find(old_semester_id).course_plan.remove_cis_sections sections_from_course(course, Semester.find(old_semester_id))
    end
    if new_semester_id == -1
      @user.course_bin.cis_courses.concat(course)
    else
      course.semesters.concat(Semester.find(new_semester_id))
    end

    if new_semester_id != -1
      semester_obj = Semester.find(new_semester_id)
    end

    render :partial => 'course', :object => course, :locals => {:semester_obj => semester_obj || nil, :effect => true}
  end  
  
  def auto_complete_for_course_number
    @courses = CisSubject.search_for_course(params[:course][:number])
    render :partial => 'auto_complete_course'
  end

  # added for semester schedule
  def show_semester_schedule
      @semester = Semester.find(params[:id]);

      render :update do |page|
            page.replace_html 'times_row', :partial => 'times_row', :locals => {:semester => @semester}
            page.replace_html 'schedule_semester_label', "#{@semester.semester} #{@semester.year}"
            page.visual_effect :blind_down, 'schedule_container'
      end

      session[:viewing_schedule] = @semester.id
  end

  def toggle_section
    user = User.find(session[:user])
    section = CisSection.find(params[:section])
    plan = user.semesters.find(params[:id]).course_plan

    if plan.cis_sections.exists? params[:section]
      plan.remove_cis_sections section
    else
      plan.add_cis_sections section
    end
      
    @semester = Semester.find(params[:id])
    
    # TODO clean this up
    @start_time = DateTime.new(0,1,1,8)
    @end_time = DateTime.new(0,1,1,21,30)
    @time_inc = 15/(24.0*60)
    @courses = @semester.cis_courses
    @plan = @semester.course_plan
    course = section.cis_semester.cis_course;

    sections = sections_from_course course, @semester

    render :update do |page|
      session[:viewing_schedule] == @semester.id and page.replace_html 'times_row', :partial => 'times_row', :locals => {:semester => @semester}
      page.replace_html "sects_#{@semester.id}_#{course.id}", :partial => 'section_choice', :collection => sections, :locals => {:semester => @semester}
    end
    
  end

  private
  # TODO doesn't work right yet
  def sections_from_course course, semester
      begin
            #return course.cis_semesters[0].cis_sections
            return course.cis_semesters.find(:first, :conditions => ["semester = ? and year = ?", semester.semester, semester.year]).cis_sections
      rescue
            return nil
      end
  end

end
