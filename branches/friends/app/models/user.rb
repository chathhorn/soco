require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :course_bin, :dependent => :destroy
  has_many :semesters, :dependent => :destroy
  belongs_to :college
  belongs_to :major
  has_and_belongs_to_many :friends, :class_name => 'User', :association_foreign_key => 'friend_id', :join_table => 'friends_users'
  
  validates_uniqueness_of :username
  validates_presence_of :username
  validates_presence_of :start_sem
  validates_presence_of :start_year
  validates_presence_of :college
  validates_presence_of :major
  validates_presence_of :password_hash
  
  after_create :create_dependancies
  
  def self.authenticate(username, password)
    find(:first, 
      :conditions => ["username = ? and password_hash = ?", username, Digest::SHA1.hexdigest(password)]
    )
  end

  def password=(str)
    unless str.empty? 
      write_attribute("password_hash", Digest::SHA1.hexdigest(str))
    end
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
      semesters.create(:year => i_year, :semester => i_semester)  
      if i_semester == 'SP'
        i_semester = 'FA'
      else
        i_semester = 'SP'
        i_year += 1
      end
    end
  end

  def self.search(query)
    if query == ""
      return []
    end
      
    terms = query.split
    fields = ['first_name', 'last_name', 'username', 'email']
    
    fields.collect! {|field| field += " LIKE ?"}
    
    query_string_short = fields.join " OR "
    
    query_string = []
    
    terms.each {|term| query_string.push query_string_short}
    
    conditions = [query_string.join(" AND "),]
    
    terms.each {|term| fields.each {|field| conditions.push '%' << term << '%' } }
    
    users = find :all,
      :conditions => conditions,
      :limit => 100
    
    return users   
  end  

end
