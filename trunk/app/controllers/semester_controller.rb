class SemesterController < ApplicationController
  def show
    @title = 'View Semester Schedule'
    @semester = Semester.find(params[:id])
    
    @start_time = DateTime.new(0,1,1,8)
    @end_time = DateTime.new(0,1,1,21,30)
    @time_inc = 15/(24.0*60) #15.0/(24.0*60.0)
#        time.strftime("%H:%M")
#      end
  end

  def edit
    @title = 'Edit Semester Schedule'
  end

end
