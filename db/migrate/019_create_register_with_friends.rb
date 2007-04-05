class CreateRegisterWithFriends < ActiveRecord::Migration
  def self.up
    create_table :register_with_friends do |t|
    end
  end

  def self.down
    drop_table :register_with_friends
  end
end
