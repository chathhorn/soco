class Semester < ActiveRecord::Base
  has_and_belongs_to_many :cis_courses
  has_one :course_plan, :dependent => :destroy
  belongs_to :user

  after_create :create_dependancies
  
  #SEMESTER YEAR
  def to_s
    return semester.to_s + " " + year.to_s
  end
  
  private
  #create course plan upon creation of this object
  def create_dependancies
    create_course_plan()
  end
  
end
