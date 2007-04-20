class CisCourse < ActiveRecord::Base
  has_many :cis_semesters
  belongs_to :cis_subject
  belongs_to :course_dependency
  has_and_belongs_to_many :course_bins
  has_and_belongs_to_many :semesters
  has_many :shared_courses
  
  def iterate_users_semesters(user)
    #find all relationship objects for this user id AND cis_course
    
    shared_course_list = shared_courses.find :all, :include => 'relationship', :conditions => ["relationships.user_id = ?", user.id]
    
    shared_course_list.each do |shared|
      friend = shared.relationship.friend
      
      semester = Semester.find_by_sql ["SELECT semesters.* FROM semesters LEFT OUTER JOIN cis_courses_semesters ON cis_courses_semesters.semester_id = semesters.id WHERE semesters.user_id = ? AND cis_courses_semesters.cis_course_id = ? LIMIT 1", friend.id, id]
    
      yield shared.id, friend, semester
    end
  end
  
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
