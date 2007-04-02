require File.dirname(__FILE__) + '/../test_helper'

class UserFriendsTest < Test::Unit::TestCase

 fixtures :users

  # Replace this with your real tests.
  def test_truth
    assert true
  end

#this test shows that you can add a new user
  def test_add_new_user
      user = User.new(:username=>'forest', :password=>"gump", :start_year=>'2009', :start_sem=>'FA', :birthday=>'1990-10-29', :college => College.find(:first))
      user.save
      puts user.id
      assert_equal('forest', user.username)
      first_name = user.first_name
      last_name  = user.last_name
  end
  
# this test shows that when you initialize a new user, he has no friends by default   
  def test_zerofriends
    user = User.new(:username=>'forest', :password=>"gump", :start_year=>'2009', :start_sem=>'FA', :birthday=>'1990-10-29', :college => College.find(:first))
    assert_equal(user.friends, [])
  end

#  this test shows that you can be your own friend
  def test_NoRestrictionsBeingMyOwnFriend
      bfound = 0;
      user = User.new(:username=>'forest', :password=>"gump", :start_year=>'2009', :start_sem=>'FA', :birthday=>'1990-10-29', :college => College.find(:first))
      user.friends.concat user
      @friends_all = User.find :all, :order => 'last_name ASC, first_name ASC'  
      user.friends.each do |eUser |
        if(eUser.id == user.id)
          bfound = 1
        end
      end
      assert_equal(bfound, 1)
      user.destroy
  end
  
#  this test shows that you can all user's excluding this user
  def test_addFriends
      bFound = false;
      user1 = User.new(:username=>'forest1', :password=>"gump1", :start_year=>'2009', :start_sem=>'FA', :birthday=>'1990-10-29', :college => College.find(:first))
      user2 = User.new(:username=>'forest2', :password=>"gump2", :start_year=>'2007', :start_sem=>'FA', :birthday=>'1930-10-29', :college => College.find(:first))
      user1.save
      user2.save
      @friends_all = User.find :all, :order => 'last_name ASC, first_name ASC'  
      @friends_all.each do |eUser |
        if(eUser.id != user1.id) 
          bFound = true
          friend = User.find eUser.id
          user1.friends.concat friend
        end
      end
      assert bFound
      assert_equal(user1.friends.length, 1)
#      oneLess = @friends_all.length - 1;
#      assert_equal(user1.friends.length, oneLess)
      user1.destroy
      user2.destroy
  end
  
#  def addFriend
#      first_name = @user.first_name
#      last_name  = @user.last_name
#      @friends_all = User.find :all, :order => 'last_name ASC, first_name ASC'
#      @friends_all.each do |aUser | 
#      if(first_name == aUser.first_name and last_name == aUser.last_name)
#          friend = User.find aUser.id
#          user = User.find session[:user]
#          puts "friend = " + friend.to_s
#          bfound = 0
#          user.friends.each do |eUser |
#            if(eUser.id == aUser.id)
#              bfound = 1
#            end
#          end
#          if(bfound == 1)
#            puts 'friend id already exists'
#          else
#            puts 'adding friend id'
#            user.friends.concat friend
#            friend.friends.concat user
#          end
#      end
#  end
#  end
 
end
