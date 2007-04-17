class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'
  
  has_many :shared_courses
end
