class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  
  has_many :shared_courses, :dependent => :destroy
  
  def Relationship.find_by_user_and_friend(user_id, friend_id)
    relationships = find :all, :conditions => ["user_id = ? AND friend_id = ?", user_id, friend_id]
    
    if not relationships.empty?
      return relationships[0]
    end
    
    return nil
  end
end
