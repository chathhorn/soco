class RegisterWithFriend < ActiveRecord::Base
  validates_uniqueness_of :friends_users_id, :scope => [:friends_users_id, :cis_courses_id]
end
