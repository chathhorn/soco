class CisSemester < ActiveRecord::Base
  has_many :cis_sections
  belongs_to :cis_course

  def semester_word
    case semester
      when :SP
        "Spring"
      when :FA
        "Fall"
      when :SU
        "Summer"
    end
  end
end
