require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

 fixtures :users, :colleges, :majors, :course_bins, :semesters

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

  assert_equal temp.save, false
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
 end
 
 def test_semester_creation
    temp = User.new(:username=>'nonie2', 
                   :password=>"1234567",
                   :first_name=>'abcd',
                   :last_name=>'cdef', 
                   :email=>'nsonie2@uiuc.edu',
                   :start_year=>'2009',
                   :start_sem=>'FA', 
                   :birthday=>'1990-10-29', 
                   :college => College.find(:first),
                   :major => Major.find(:first)
                   )     
    
    assert_equal(true, temp.save)
    
    sems = Semester.find(:all, :conditions => ["user_id = ?", temp.id] )
    
    assert_equal 8, sems.size
 
 end
 
 
 def test_semester_destruction
     temp = User.new(:username=>'nonie2', 
                   :password=>"1234567",
                   :first_name=>'abcd',
                   :last_name=>'cdef', 
                   :email=>'nsonie2@uiuc.edu',
                   :start_year=>'2009',
                   :start_sem=>'FA', 
                   :birthday=>'1990-10-29', 
                   :college => College.find(:first),
                   :major => Major.find(:first)
                   )     
    
    assert_equal(true, temp.save)
    
    sems = Semester.find(:all, :conditions => ["user_id = ?", temp.id] )
    
    assert_equal 8, sems.size 
    
    temp.destroy
    
    sems = Semester.find(:all, :conditions => ["user_id = ?", temp.id] )
    
    assert_equal 0, sems.size
 end
 
 def test_duplicate_user_real_name 
  
  # Create a new user 
  user1 = User.new(:username=>'koala', 
   :password=>"koala1",
   :first_name=>'Chris',
   :last_name=>'Horneck', 
   :email=>'chorneck@uiuc.edu',
   :start_year=>'2009',
   :start_sem=>'FA', 
   :birthday=>'1990-10-29', 
   :college => College.find(:first),
   :major => Major.find(:first)
   )                     
  #Save the user 
  assert user1.save
  
  #Create a new user with the same real name 
  user2 = User.new(:username=>'koala2', 
   :password=>"koala1",
   :first_name=>'Chris',
   :last_name=>'Horneck', 
   :email=>'koala1@uiuc.edu',
   :start_year=>'2009',
   :start_sem=>'FA', 
   :birthday=>'1990-10-29', 
   :college => College.find(:first),
   :major => Major.find(:first)
   )            
  assert user2.save 
  
  user1.destroy 
  user2.destroy 
end

def test_invalid_birthday
  temp = User.new(:username=>'fake', 
                 :password=>"userpassword",
                 :first_name=>'abcd',
                 :last_name=>'cdef', 
                 :email=>'none@none.com',
                 :start_year=>'2009',
                 :start_sem=>'FA', 
                 :birthday=>'1990-2-31', 
                 :college => College.find(:first),
                 :major => Major.find(:first)
                 )                      

  assert_equal temp.save, false
end
 
end
