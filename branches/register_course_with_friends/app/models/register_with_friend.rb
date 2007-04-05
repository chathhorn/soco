class RegisterWithFriend < ActiveRecord::Base
    has_many :friends_users
    has_many :cis_courses
end
