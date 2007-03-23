class CourseDependency < ActiveRecord::Base
  acts_as_graph
  has_many :cis_courses
  
  def to_s
    if type == :COURSE
      return cis_courses[0].to_s
    end
  
    courses = []
    children.each { |child| courses.push child.to_s }
    
    if type == :OR
      return courses.join(" or ")
    end
    
    return courses.join(" and ")
  end
end
