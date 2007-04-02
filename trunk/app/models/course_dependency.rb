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
    
    #type is either COURSE or AND
    
    return "(" << courses.join(" and ") << ")"
  end
  
  def to_s_helper
    if node_type == :COURSE
      return cis_courses[0].to_s
    end
    
    return to_s
  end
end
