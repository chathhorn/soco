class CisSemester < ActiveRecord::Base
  has_many :cis_sections
  belongs_to :cis_course
end
