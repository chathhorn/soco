# vim: shiftwidth=2 shiftwidth=2 expandtab
class SemesterController < ApplicationController
  def show
    @semester = Semester.find(params[:id])
    
    @start_time = DateTime.new(0,1,1,8)
    @end_time = DateTime.new(0,1,1,21,30)
    @time_inc = 15/(24.0*60) #15.0/(24.0*60.0)
#        time.strftime("%H:%M")
#      end
  end

  # added for semester schedule
  def show_semester_schedule
    @semester = Semester.find(params[:id]);

    render :update do |page|
        page.replace_html 'times_row', :partial => 'times_row', :locals => {:semester => @semester}
        page.replace_html 'schedule_semester_label', "#{@semester.semester} #{@semester.year}"
        page.visual_effect :blind_down, 'schedule_container'
    end

  end

  def toggle_section
    user = User.find session[:user]
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

    sections = course.sections_for_semester @semester

    render :update do |page|
      page.replace_html 'times_row', :partial => 'times_row', :locals => {:semester => @semester}
      page.replace_html "sects_#{@semester.id}_#{course.id}", :partial => 'section_choice', :collection => sections, :locals => {:semester => @semester}
    end
  end

end
