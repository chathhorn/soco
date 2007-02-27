require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

 fixtures :users

  def test_invalid_authentication
    #finding something that is not in database
    #to check if it returning nil 
    assert_nil User.authenticate("%$%$%$%$%$%$%","_)#(%*%#(#")
  end
  
  def test_duplicate_user_object_creation
    james = User.new(:username=>'james', :password=>"bond")
    assert_equal(james.save, false)
  end
  
  def test_successful_user_object_creation
  
    nikhil = User.new(
                      :username=>'nikhil', 
                      :password=>'sonie123',
                      :first_name=>'abcd',
                      :last_name=>'cdef', 
                      :email=>'nsonie2@uiuc.edu',
                      :start_year=>'2009',
                      :start_sem=>'FA', 
                      :birthday=>'1990-10-29', 
                      :college => College.find(:first),
                      :major => Major.find(:first)
                      )                                
    assert_equal(true, nikhil.save) 
    nikhil.destroy 
  end
  
  def test_password_gt_6_char
  
      #password should be more than 6 characters
      temp = User.new(:username=>'nikhil1', 
                      :password=>"sonie1",
                      :first_name=>'abcd',
                      :last_name=>'cdef', 
                      :email=>'nsonie2@uiuc.edu',
                      :start_year=>'2009',
                      :start_sem=>'FA', 
                      :birthday=>'1990-10-29', 
                      :college => College.find(:first),
                      :major => Major.find(:first)
                      )  # pass case
      ret_val = temp.save
      temp.destroy
      assert_equal(true, ret_val)  
 
      #password should be more than 6 characters
      temp = User.new(:username=>'nikhil1', 
                      :password=>"sonie",
                      :first_name=>'abcd',
                      :last_name=>'cdef', 
                      :email=>'nsonie2@uiuc.edu',
                      :start_year=>'2009',
                      :start_sem=>'FA', 
                      :birthday=>'1990-10-29', 
                      :college => College.find(:first),
                      :major => Major.find(:first)
                      )  #fail case
      ret_val = temp.save
      temp.destroy
      assert_equal(false, ret_val)  

  end
 
  def test_case_sensitivity
    #find something that in the database
    #check if the username and password are stored correctly 
    assert_nil(User.authenticate("JAMES","BOND"))
    assert_nil(User.authenticate("James","Bond"))  
    assert User.authenticate("james", "bond")
  end
  
  def test_valid_authentication
    assert_equal("james", User.authenticate("james","bond").username)
    assert_equal(Digest::SHA1.hexdigest("bond"), User.authenticate("james","bond").password_hash)
  end
 

 def test_null_username_object_creation
 
 # should fail as username cannot be null
 temp = User.new(:username=>'  ', 
                 :password=>"nsonie2",
                 :first_name=>'abcd',
                 :last_name=>'cdef', 
                 :email=>'nsonie2@uiuc.edu',
                 :start_year=>'2009',
                 :start_sem=>'FA', 
                 :birthday=>'1990-10-29', 
                 :college => College.find(:first),
                 :major => Major.find(:first)
                 )   
  ret_val = temp.save                                    
  temp.destroy
  assert_equal(false, ret_val)
 end
 
 def test_null_password_object_creation
 
 # should fail as username cannot be null
 temp = User.new(:username=>'nonie2', 
                 :password=>" ",
                 :first_name=>'abcd',
                 :last_name=>'cdef', 
                 :email=>'nsonie2@uiuc.edu',
                 :start_year=>'2009',
                 :start_sem=>'FA', 
                 :birthday=>'1990-10-29', 
                 :college => College.find(:first),
                 :major => Major.find(:first)
                 )     
  ret_val = temp.save
  temp.destroy
  assert_equal(false, ret_val)
  
 end
  
 def test_proper_email_format
 
 # should fail as we are not using *@*.*
 temp = User.new(:username=>'nsonie2', 
                 :password=>"nsonie2",
                 :first_name=>'abcd',
                 :last_name=>'cdef', 
                 :email=>'nsonie2',
                 :start_year=>'2009',
                 :start_sem=>'FA', 
                 :birthday=>'1990-10-29', 
                 :college => College.find(:first),
                 :major => Major.find(:first)
                 )                      

  ret_val = temp.save
  temp.destroy

 # should pass as it is valid
 temp1 = User.new(:username=>'nsonie2', 
                 :password=>"nsonie2",
                 :first_name=>'abcd',
                 :last_name=>'cdef', 
                 :email=>'nsonie2@uiuc.edu',
                 :start_year=>'2009',
                 :start_sem=>'FA', 
                 :birthday=>'1990-10-29', 
                 :college => College.find(:first),
                 :major => Major.find(:first)
                 )                     
                 
 assert_equal(true, temp1.save)  
 temp1.destroy
 assert_equal(false, ret_val)  
 end
 
end
