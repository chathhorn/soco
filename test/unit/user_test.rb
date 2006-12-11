require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :users
#  fixtures :username_password_fail_cases, :username_password_pass_cases
  # Replace this with your real tests.
  def test_truth
    assert true
  end
 
  def test_username_passaword_fail_cases
   
    assert_equal("james", User.authenticate("james","bond").username)
    
    #assert_nil(user.find_by_username(nikhil.username))
  end
  
#  def test_username_password_pass_case
#  
#   #create a user object
#    assert_equal("james", User.authenticate("james","bond").username)
#    assert_equal("bond", User.authenticate("james","bond").password_hash)
# end
  
  
end
