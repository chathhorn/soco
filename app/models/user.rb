require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :course_bin
  has_one :friend_list
  has_many :semesters
  belongs_to :college
  belongs_to :major
  has_and_belongs_to_many :friend_lists


  def self.authenticate(username, password)
    find(:first, 
      :conditions => ["username = ? and password_hash = ?", username, Digest::SHA1.hexdigest(password)]
    )
  end

  def password=(str)
    write_attribute("password", Digest::SHA1.hexdigest(str))
  end

  def password
    "" 
  end

end
