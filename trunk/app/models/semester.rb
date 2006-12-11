class Semester < ActiveRecord::Base
  has_and_belongs_to_many :cis_courses
  has_one :course_plan, :dependent => :destroy
  belongs_to :user

  before_create :create_dependancies
  
  
  private
  def create_dependancies
    create_course_plan()
  end
  
end
