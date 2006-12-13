require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :course_bin, :dependent => :destroy
  has_many :semesters, :dependent => :destroy
  belongs_to :college
  belongs_to :major
  has_and_belongs_to_many :friends, :class_name => :user
  
  validates_uniqueness_of :username
  
  before_create :create_dependancies
  
  def self.authenticate(username, password)
    find(:first, 
      :conditions => ["username = ? and password_hash = ?", username, Digest::SHA1.hexdigest(password)]
    )
  end

  def password=(str)
    write_attribute("password_hash", Digest::SHA1.hexdigest(str))
  end

  def password
    "" 
  end
  
  private
  def create_dependancies
    create_course_bin()

    #create 8 default semesters
    i_year = start_year.to_i;
    i_semester = start_sem;
    for i in 1..8
      create_in_semesters(:year => i_year, :semester => i_semester)  
      if i_semester == 'SP'
        i_semester = 'FA'
      else
        i_semester = 'SP'
        i_year += 1
      end
    end
  end

end