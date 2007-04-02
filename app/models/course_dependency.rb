class CourseDependency < ActiveRecord::Base
  acts_as_graph :edge_table => 'course_dependency_edges'
  has_many :cis_courses
  
  def to_s
    courses = []
    children.each { |child| courses.push child.to_s_helper }
    
    if node_type == :CONCURRENT
      return "(concurrently with " << courses.join(" and ") << ")"
    elsif node_type == :OR
      return "(" << courses.join(" or ") << ")"
    end
    
    return "(" << courses.join(" and ") << ")"
  end
  
  def to_s_helper
    if node_type == :COURSE
      return cis_courses[0].to_s
    end
    
    return to_s
  end
  
  def is_satisfied?(course_id, semester_id, user)
    children.each do |child|
      if not child.is_satisfied_helper?(course_id, semester_id, user)
        return false
      end
    end

    return true
  end
  
  protected
  def is_satisfied_helper?(course_id, semester_id, user)
    case node_type
      when :COURSE
        return look_for_course_in_earlier_semester(course_id, semester_id, user) 
      when :OR
        children.each do |child|
          if child.is_satisfied_helper?(course_id, semester_id, user)
            return true
          end
        end
        return false
      when :AND
        result = true
        children.each do |child|
          result &= child.is_satisfied_helper?(course_id, semester_id, user)
        end
        return result
      else #:CONCURRENT
        result = true
        children.each do |child|
          result &= child.is_satisfied_helper?(course_id, semester_id + 1, user)
        end
        return result
    end
  end
  
  private
  def look_for_course_in_earlier_semester(course_id, max_semester_id, user)
    user.semesters.each do |semester|
      if semester.id == max_semester_id
        break
      end
      semester.cis_courses.each do |course|
        if course.course_dependency.id == id
          return true
        end
      end
    end

    return false
  end
end
