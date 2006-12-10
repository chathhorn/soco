class CisCourse < ActiveRecord::Base
  has_many :cis_semesters
  belongs_to :cis_subject
  has_and_belongs_to_many :course_bins
  has_and_belongs_to_many :semesters
end
