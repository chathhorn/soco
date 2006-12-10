class User < ActiveRecord::Base
  has_one :course_bin
  has_one :friend_list
  has_many :semesters
  belongs_to :college
  belongs_to :major
  
  def self.validate_user username, password
    return User.find(:first, :conditions => ["username=? AND password_hash = SHA1(?)", username, password])
  end
end
