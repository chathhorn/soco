class User < ActiveRecord::Base
  has_one :course_bin
  has_one :friend_list
  has_many :semesters
  
  def self.validate_user username, password
    return User.find_by_username(username, :conditions => ["password = SHA1(?)", password]);  
  end
end
