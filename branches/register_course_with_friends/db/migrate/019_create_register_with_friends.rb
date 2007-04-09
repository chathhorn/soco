class CreateRegisterWithFriends < ActiveRecord::Migration

  def self.up
    create_table :register_with_friends do |t|
    t.column "friends_users_id", :integer, :null => false
    t.column "cis_courses_id",   :integer, :null => false
  end 

  def self.down
    drop_table :register_with_friends
  end
end
