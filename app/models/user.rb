class User < ActiveRecord::Base
  has_one :major
  has_one :college
  has_one :course_bin
  has_one :friend_list
  has_many :semesters
end
