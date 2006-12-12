require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

 fixtures :users

#  fixtures :username_password_fail_cases, :username_password_pass_cases
  # Replace this with your real tests.
  def test_truth
    assert true
  end
 
  def test_username_passaword_fail_cases
    #finding something that is not in database
    #to check if it returning nil 
    assert_nil User.authenticate("nikhil","sonie")
  end
  
 def test_username_password_pass_case
  #find something that in the database
  #check if the username and password are stored correctly 
    assert_equal("james", User.authenticate("james","bond").username)
    assert_equal(Digest::SHA1.hexdigest("bond"), User.authenticate("james","bond").password_hash)
 end
 
 def test_validate_uniqueness

 end
 
end
