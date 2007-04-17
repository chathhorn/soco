class SharedCourse < ActiveRecord::Base
  belongs_to :connection
  belongs_to :cis_course
  
  def semester
    #look at connection (has 2 though)
    #get semester for friend
  end
end
