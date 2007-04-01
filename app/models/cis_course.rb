class CisCourse < ActiveRecord::Base

  has_many :cis_semesters
  belongs_to :cis_subject
  belongs_to :course_dependency
  has_and_belongs_to_many :course_bins
  has_and_belongs_to_many :semesters
  
  def dependencies_satisfied
    @dependencies_satisfied
  end
  
  def dependencies_satisfied=(ds)
    @dependencies_satisfied = ds
  end
   
  def to_s
    return cis_subject.to_s + ' ' + number.to_s
  end
  

end
