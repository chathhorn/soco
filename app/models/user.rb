require 'digest/sha1'

class User < ActiveRecord::Base
  attr_accessor :password

  has_one :course_bin, :dependent => :destroy
  has_many :semesters, :dependent => :destroy
  belongs_to :college
  belongs_to :major
  has_and_belongs_to_many :friends, :class_name => 'User', :association_foreign_key => 'friend_id', :join_table => 'friends_users'
  
  validates_uniqueness_of :username, :email
  validates_presence_of :username, :start_sem, :start_year, :college, :major, :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :password, :within => 6..40, :if => :needs_password_update?
  validates_confirmation_of :password, :if => :needs_password_update?

  before_save :encrypt_password
  after_create :create_dependancies
  
  def self.authenticate(username, password)
    find(:first, 
      :conditions => ["username = ? and password_hash = ?", username, Digest::SHA1.hexdigest(password)]
    )
  end

  private
  def encrypt_password
    unless password.empty?
      self.password_hash = Digest::SHA1.hexdigest(password)
    end
  end

  def needs_password_update?
    password_hash.empty? or not password.empty?
  end
  
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
