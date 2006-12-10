class Semester < ActiveRecord::Base
  has_and_belongs_to_many :cis_courses
  has_one :course_plan

end
