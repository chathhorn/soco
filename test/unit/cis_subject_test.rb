require File.dirname(__FILE__) + '/../test_helper'

class CisSubjectTest < Test::Unit::TestCase
  fixtures :cis_subjects

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_failure_case
    zulu = CisSubject.new(:id=>3, :code=>'ZULU')
    zulu.save  
    assert CisSubject.search_for_course('PSYCH').empty?
    assert CisSubject.search_for_course(' math').empty?
  end
  
  def test_pass_case
  
    assert_equal(CisSubject.search_for_course('CS')[0].code, 'CS') 
    assert_equal(2,CisSubject.search_for_course("").size)
  
  # a bug in the code
    assert_equal(CisSubject.search_for_course(''),
                 CisSubject.search_for_course(' '))
   
  end                 
end
