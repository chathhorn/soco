module SemesterHelper
  def classes day
    @semester = Semester.find(params[:id])
    render :partial => 'section', 
      :collection => @semester.course_plan.cis_sections.find(:all, 
      :conditions =>["days LIKE ?",'%'+day+'%'])
  end
end
