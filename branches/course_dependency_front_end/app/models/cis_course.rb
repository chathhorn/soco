class CisCourse < ActiveRecord::Base

  has_many :cis_semesters
  belongs_to :cis_subject
  belongs_to :course_dependency
  has_and_belongs_to_many :course_bins
  has_and_belongs_to_many :semesters
  attr_accessor :dependencies_satisfied

   
  def to_s
    return cis_subject.to_s + ' ' + number.to_s
  end
  

end
