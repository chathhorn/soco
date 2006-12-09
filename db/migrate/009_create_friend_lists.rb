class CreateFriendLists < ActiveRecord::Migration
  def self.up
    create_table :friend_lists do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :friend_lists
  end
end
