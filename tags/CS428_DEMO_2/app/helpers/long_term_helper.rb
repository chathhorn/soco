module LongTermHelper

  def lookup_semester time
    if (time.month == 12 or time.month < 5)
      return 'SP'
    elsif (time.month < 8)
      return 'SU'
    else
      return 'FA'
    end
  end

  def lookup_semester_word time
    code = lookup_semester time
    if (code == 'SP')
      return 'Spring'
    elsif (code == 'FA')
      return 'Fall'
    else (code == 'SU')
      return 'Summer'
    end
  end
  
  def lookup_year time
    if (time.month == 12) 
      return (time.year + 1).to_s;
    else 
      return time.year.to_s
    end
  end

  # brought over for semester view
  def classes day, semester
    semester == -1 && return
    @semester = Semester.find(semester)
    render :partial => 'section', 
      :collection => @semester.course_plan.cis_sections.find(:all, 
      :conditions =>["days LIKE ?",'%'+day+'%'])
  end

  def section_in_plan?(section, semester)
        begin
              Semester.find(semester).course_plan.cis_sections.find section
        rescue
              return false
        else
              return true
        end
  end


end
