class CisCourse < ActiveRecord::Base
  has_many :cis_semesters
  belongs_to :cis_subject
end
