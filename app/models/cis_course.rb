class CisCourse < ActiveRecord::Base
  has_many :cis_semesters
  belongs_to :cis_subject
  belongs_to :course_dependency
  has_and_belongs_to_many :course_bins
  has_and_belongs_to_many :semesters
  has_many :shared_courses
  
  def to_s
    return cis_subject.to_s + ' ' + number.to_s
  end
  
  def dependencies_satisfied(semester_id, user_id)
    if semester_id == -1
      return true
    end
    
    user = User.find(user_id)
   
    return course_dependency.is_satisfied?(id, semester_id, user)
  end
end
